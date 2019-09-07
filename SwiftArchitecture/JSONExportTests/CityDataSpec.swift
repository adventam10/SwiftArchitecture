//
//  CityDataSpec.swift
//  JSONExportTests
//
//  Created by am10 on 2019/09/07.
//  Copyright © 2019 am10. All rights reserved.
//

import Quick
import Nimble
@testable import JSONExport

class CityDataSpec: QuickSpec {
    override func spec() {
        describe("CityDataList") {
            let text = """
 {"cityDataList": [
 { "cityId": "270000", "name": "大阪", "area": 4 },
 { "cityId": "020010", "name": "青森", "area": 1 }
 ]}
 """
            let cityDataList = try? JSONDecoder().decode(CityDataList.self, from: text.data(using: .utf8)!)
            it ("decodable") {
                expect(cityDataList).notTo(beNil())
                expect(cityDataList?.cityDataList).to(haveCount(2))
                let cityData = cityDataList?.cityDataList?.first
                expect(cityData).notTo(beNil())
                expect(cityData?.cityId).to(equal("270000"))
                expect(cityData?.name).to(equal("大阪"))
                expect(cityData?.area).to(equal(4))
            }
        }
        
        describe("CityData") {
            let text = """
 { "cityId": "270000", "name": "大阪", "area": 4 }
 """
            let cityData = try? JSONDecoder().decode(CityData.self, from: text.data(using: .utf8)!)
            it ("decodable") {
                expect(cityData).notTo(beNil())
                expect(cityData?.cityId).to(equal("270000"))
                expect(cityData?.name).to(equal("大阪"))
                expect(cityData?.area).to(equal(4))
            }
        }
    }
}
