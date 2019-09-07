//
//  WeatherAPI.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/09/07.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation

public protocol WeatherAPI: Request {
}

extension WeatherAPI {
    public var method: HTTPMethod {
        return .get
    }
    
    public var baseURL: URL {
        return URL(string: "http://weather.livedoor.com/forecast/webservice/json")!
    }
    
    public var path: String {
        return ""
    }
    
    public var headers: [String: String]? {
        return nil
    }
    
    public var timeout: TimeInterval {
        return 60
    }
    
    public var contentType: String {
        return ""
    }
}

public struct WeatherDetailAPI: WeatherAPI {
    let cityId: String
    
    public var parameter: [String: Any]? {
        return ["city": cityId]
    }
    
    public var path: String {
        return "v1"
    }
    
    public init(cityId: String) {
        self.cityId = cityId
    }
}
