//
//  APIClient.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/09/29.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation
import Alamofire

final class APIClient {
    
    static let shared = APIClient()
    
    private init() {}
    
    func requestWeather(cityId: String, completion: @escaping (Result<Weather, APIError>) -> Void) {
        Alamofire.request(URL(string: "http://weather.livedoor.com/forecast/webservice/json/v1?city=\(cityId)")!).responseJSON { (dataResponse) in
            DispatchQueue.main.async {
                if let error = dataResponse.error {
                    completion(.failure(.network(error.localizedDescription)))
                    return
                }
                
                if dataResponse.response?.statusCode != 200 {
                    completion(.failure(.server))
                    return
                }
                
                guard let data = dataResponse.data else {
                    completion(.failure(.notData))
                    return
                }
                
                if let result = try? JSONDecoder().decode(Weather.self, from: data) {
                    completion(.success(result))
                    return
                }
                completion(.failure(.invalidJSON))
            }
        }
    }
}

public enum APIError: Swift.Error {
    case network(String)
    case server
    case notData
    case invalidJSON
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .network(let description):
            return description
        case .server:
            return "サーバーと通信できません。"
        case .notData:
            return "データなし"
        case .invalidJSON:
            return "JSONパース失敗"
        }
    }
}

public enum Result<Success, Failure: Error> {
    case success(Success)
    case failure(Failure)
}
