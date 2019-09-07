//
//  Error.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/09/03.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation

public enum APIError: Swift.Error {
    case network
    case notFound
    case invalidJSON(String?)
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .network:
            return ""
        case .notFound:
            return ""
        case .invalidJSON(let data):
            if let data = data {
                return NSLocalizedString("error_json_parse", comment: "") + "\n" + data
            }
            return NSLocalizedString("error_json_parse", comment: "") + "\n" + "nil"
        }
    }
}
