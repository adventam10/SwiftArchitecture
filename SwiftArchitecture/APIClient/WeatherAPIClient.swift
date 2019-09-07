//
//  WeatherAPIClient.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/09/04.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation
import ReactiveSwift

public protocol WeatherAPIClient: APIClient {
    func send<T>(request: Request) -> SignalProducer<T, APIError> where T: Codable
}

public final class DefaultAPIClient: WeatherAPIClient {
    enum CompletionResult<T> where T: Codable {
        case success(T)
        case failure(APIError)
    }
    
    public init() {
    }
    
    public func send<T>(request: Request) -> SignalProducer<T, APIError> where T: Codable {
        return SignalProducer<T, APIError> { [unowned self] (innerObserver, _) in
            self.send(request: request) {
                switch self.completion(result: $0, type: T.self) {
                case .success(let response):
                    innerObserver.send(value: response)
                    innerObserver.sendCompleted()
                case .failure(let error):
                    innerObserver.send(error: error)
                }
            }
        }
    }
    
    private func completion<T>(result: APIResult, type: T.Type) -> CompletionResult<T> {
        switch result {
        case .success(let response):
            if response.statusCode == 200 {
                guard let data: T = self.decode(response.data) else {
                    let dataText = response.data.flatMap { String(data: $0, encoding: .utf8) }
                    return .failure(.invalidJSON(dataText))
                }
                return .success(data)
            } else {
                return .failure(.network)
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    private func decode<T>(_ data: Data?) -> T? where T: Codable {
        guard let data = data else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
