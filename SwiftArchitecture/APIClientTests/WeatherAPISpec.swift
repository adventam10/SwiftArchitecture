//
//  WeatherAPISpec.swift
//  APIClientTests
//
//  Created by am10 on 2019/09/07.
//  Copyright © 2019 am10. All rights reserved.
//

import Quick
import Nimble
@testable import APIClient

class WeatherAPISpec: QuickSpec {
    override func spec() {
        describe("WeatherDetailAPI makeRequest method") {
            let request = WeatherDetailAPI(cityId: "AAA").makeRequest()
            it("sets http parameter") {
                expect(request?.url?.absoluteString).to(equal("http://weather.livedoor.com/forecast/webservice/json/v1?city=AAA"))
                let emptyHeaderFields: [String: String] = [:]
                expect(request?.allHTTPHeaderFields).to(equal(emptyHeaderFields))
                expect(request?.timeoutInterval).to(equal(60))
            }
        }
    }
}
