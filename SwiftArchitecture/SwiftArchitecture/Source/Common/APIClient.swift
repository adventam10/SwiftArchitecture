//
//  APIClient.swift
//  SwiftArchitecture
//
//  Created by makoto on 2019/04/28.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift

protocol BaseAPIProtocol {
    associatedtype ResponseType
    
    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
}

extension BaseAPIProtocol {
    var baseURL: URL {
        return URL(string: "http://weather.livedoor.com/forecast/webservice/json")!
    }
    var headers: HTTPHeaders? {
        return nil // 必要であれば個々に設定
    }
}

// MARK: - BaseRequestProtocol
protocol BaseRequestProtocol: BaseAPIProtocol, URLRequestConvertible {
    var parameters: Parameters? { get }
    var encoding: URLEncoding { get }
}

extension BaseRequestProtocol {
    var encoding: URLEncoding {
        // parameter の変換の仕方を設定
        // defaultの場合、get→quertString、post→httpBodyとよしなに行ってくれる
        return URLEncoding.default
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.timeoutInterval = TimeInterval(60)
        if let params = parameters {
            urlRequest = try encoding.encode(urlRequest, with: params)
        }
        
        return urlRequest
    }
}

struct WeatherRequest: BaseRequestProtocol {
    typealias ResponseType = Weather
    
    let method: HTTPMethod = .get
    let path = "v1"
    var parameters: Parameters? = nil
}

enum APIResult {
    case success(Codable)
    case failure(Error)
}

// MARK: - ErrorResponse
struct ErrorResponse: Error, CustomStringConvertible {
    let description: String = "JSONパース失敗"
    var dataContents: String?
}

final class APIClient {
    private static let successRange = 200..<400
    private static let contentType = ["application/json"]
    public func call<T, V>(_ request: T,
                           success: @escaping (V) -> Void,
                           failure: @escaping (Error) -> Void)
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
            observe(request).startWithResult { result in
                switch (result) {
                case let .success(value):
                    success(value)
                case let .failure(error):
                    failure(error)
                }
            }
    }
    
    private func observe<T, V>(_ request: T) -> SignalProducer<V, Error>
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
            return SignalProducer<V, Error> { [unowned self] (innerObserver, disposable) in
                self.callForData(request) { response in
                    switch response {
                    case .success(let result):
                        innerObserver.send(value: result as! V)
                        innerObserver.sendCompleted()
                    case .failure(let error):
                        innerObserver.send(error: error)
                    }
                }
            }.observe(on: UIScheduler())
    }
    
    private func callForData<T, V>(_ request: T,
                                   completion: @escaping (APIResult) -> Void)
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
            customAlamofire(request).responseJSON { [unowned self] response in
                switch response.result {
                case .success:
                    completion(self.decodeData(request, response.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // JSONをDecoderしている部分
    private func decodeData<T, V>(_ request: T, _ data: Data?) -> APIResult
        where T: BaseRequestProtocol, V: Codable, T.ResponseType == V {
            if let data = data, let result = try? JSONDecoder().decode(V.self, from: data) {
                return .success(result)
            }
            // Decodeエラー時はErrorResponseを返すようにしている。またdata内容も付与しておく。
            return .failure(ErrorResponse(dataContents: String(data: data ?? Data(), encoding: .utf8)))
    }
    
    // Alamofireのメソッドのみ切り出した部分
    private func customAlamofire<T>(_ request: T) -> DataRequest
        where T: BaseRequestProtocol {
            return Alamofire
                .request(request)
                .validate(statusCode: APIClient.successRange)
                .validate(contentType: APIClient.contentType)
    }
}

extension APIClient {
    public func requestWeather(cityId: String,
                               success: @escaping (Weather)->Void,
                               failure: @escaping (String)->Void) {
        call(WeatherRequest(parameters: ["city": cityId]),
             success: success,
             failure: { error in
                failure(error.localizedDescription)
        })
    }
}
