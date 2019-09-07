//
//  APIClient.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/04/28.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation
import Alamofire

public enum HTTPMethod: String {
    case get
    case post
}

public protocol Request {
    var method: HTTPMethod { get }
    var baseURL: URL { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var timeout: TimeInterval { get }
    var parameter: [String: Any]? { get }
    var contentType: String { get }
    func makeRequest() -> URLRequest?
}

extension Request {
    var encoding: URLEncoding {
        // parameter の変換の仕方を設定
        // defaultの場合、get→quertString、post→httpBodyとよしなに行ってくれる
        return URLEncoding.default
    }
    
    public func makeRequest() -> URLRequest? {
        let url: URL
        if path.isEmpty {
            url = baseURL
        } else {
            url = baseURL.appendingPathComponent(path)
        }
        var urlRequest: URLRequest? = URLRequest(url: url)
        urlRequest?.httpMethod = method.rawValue
        urlRequest?.allHTTPHeaderFields = headers
        urlRequest?.timeoutInterval = timeout
        if let parameter = parameter {
            urlRequest = try? encoding.encode(urlRequest!, with: parameter)
        }
        return urlRequest
    }
}

public struct Response {
    let data: Data?
    let statusCode: Int?
}

public enum APIResult {
    case success(Response)
    case failure(APIError)
}

public protocol APIClient {
    func send(request: Request, completion: @escaping (APIResult) -> Void)
}

public extension APIClient {
    func send(request: Request, completion: @escaping (APIResult) -> Void) {
        guard let urlRequest = request.makeRequest() else {
            completion(.failure(.network))
            return
        }
        customAlamofire(urlRequest, contentType: request.contentType).response { response in
            completion(.success(Response(data: response.data, statusCode: response.response?.statusCode)))
        }
    }
    
    // Alamofireのメソッドのみ切り出した部分
    private func customAlamofire(_ request: URLRequest, contentType: String) -> DataRequest {
            return Alamofire
                .request(request)
                .validate(contentType: [contentType])
    }
}
