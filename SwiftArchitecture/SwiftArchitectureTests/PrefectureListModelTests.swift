//
//  PrefectureListModelTests.swift
//  SwiftArchitectureTests
//
//  Created by makoto on 2019/09/29.
//  Copyright © 2019 am10. All rights reserved.
//

import XCTest
@testable import SwiftArchitecture

final class PrefectureListModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadCityDataList() {
        let model = PrefectureListModel()
        let cityDataList = model.loadCityDataList()
        XCTAssertEqual(cityDataList.count, 47)
    }
    
    func testFilteringCityDataList() {
        let model = PrefectureListModel()
        
        // when isFavariteFilter is true
        // when selected all areas
        // when favoriteCityIds are all cities
        model.selectedAreaTypes = AreaFilterModel.Area.allCases
        model.favoriteCityIds = makeAllCitiyIds()
        var filteredList = model.filteringCityDataList(isFavoriteFilter: true)
        XCTAssertEqual(filteredList.count, 47)
        
        // when isFavariteFilter is true
        // when selected all areas
        // when favoriteCityIds are none cities
        model.selectedAreaTypes = AreaFilterModel.Area.allCases
        model.favoriteCityIds = []
        filteredList = model.filteringCityDataList(isFavoriteFilter: true)
        XCTAssertEqual(filteredList.count, 0)
        
        // when isFavariteFilter is true
        // when selected all areas
        // when favoriteCityIds are some cities
        model.selectedAreaTypes = AreaFilterModel.Area.allCases
        model.favoriteCityIds = ["016010", "020010"]
        filteredList = model.filteringCityDataList(isFavoriteFilter: true)
        XCTAssertEqual(filteredList.count, 2)
        
        // when isFavariteFilter is true
        // when selected none areas
        // when favoriteCityIds are all cities
        model.selectedAreaTypes = []
        model.favoriteCityIds = makeAllCitiyIds()
        filteredList = model.filteringCityDataList(isFavoriteFilter: true)
        XCTAssertEqual(filteredList.count, 47)
        
        // when isFavariteFilter is true
        // when selected none areas
        // when favoriteCityIds are none cities
        model.selectedAreaTypes = []
        model.favoriteCityIds = []
        filteredList = model.filteringCityDataList(isFavoriteFilter: true)
        XCTAssertEqual(filteredList.count, 0)
        
        // when isFavariteFilter is true
        // when selected none areas
        // when favoriteCityIds are some cities
        model.selectedAreaTypes = []
        model.favoriteCityIds = ["016010", "020010"]
        filteredList = model.filteringCityDataList(isFavoriteFilter: true)
        XCTAssertEqual(filteredList.count, 2)
        
        // when isFavariteFilter is true
        // when selected some areas
        // when favoriteCityIds are all cities
        model.selectedAreaTypes = [.hokkaido]
        model.favoriteCityIds = makeAllCitiyIds()
        filteredList = model.filteringCityDataList(isFavoriteFilter: true)
        XCTAssertEqual(filteredList.count, 1)
        
        // when isFavariteFilter is true
        // when selected some areas
        // when favoriteCityIds are none cities
        model.selectedAreaTypes = [.hokkaido]
        model.favoriteCityIds = []
        filteredList = model.filteringCityDataList(isFavoriteFilter: true)
        XCTAssertEqual(filteredList.count, 0)
        
        // when isFavariteFilter is true
        // when selected some areas
        // when favoriteCityIds are some cities
        model.selectedAreaTypes = [.hokkaido]
        model.favoriteCityIds = ["016010", "020010"]
        filteredList = model.filteringCityDataList(isFavoriteFilter: true)
        XCTAssertEqual(filteredList.count, 1)
        
        // when isFavariteFilter is false
        // when selected all areas
        // when favoriteCityIds are all cities
        model.selectedAreaTypes = AreaFilterModel.Area.allCases
        model.favoriteCityIds = makeAllCitiyIds()
        filteredList = model.filteringCityDataList(isFavoriteFilter: false)
        XCTAssertEqual(filteredList.count, 47)
        
        // when isFavariteFilter is false
        // when selected all areas
        // when favoriteCityIds are none cities
        model.selectedAreaTypes = AreaFilterModel.Area.allCases
        model.favoriteCityIds = []
        filteredList = model.filteringCityDataList(isFavoriteFilter: false)
        XCTAssertEqual(filteredList.count, 47)
        
        // when isFavariteFilter is false
        // when selected all areas
        // when favoriteCityIds are some cities
        model.selectedAreaTypes = AreaFilterModel.Area.allCases
        model.favoriteCityIds = ["016010", "020010"]
        filteredList = model.filteringCityDataList(isFavoriteFilter: false)
        XCTAssertEqual(filteredList.count, 47)
        
        // when isFavariteFilter is false
        // when selected none areas
        // when favoriteCityIds are all cities
        model.selectedAreaTypes = [.hokkaido]
        model.favoriteCityIds = makeAllCitiyIds()
        filteredList = model.filteringCityDataList(isFavoriteFilter: false)
        XCTAssertEqual(filteredList.count, 1)
        
        // when isFavariteFilter is false
        // when selected none areas
        // when favoriteCityIds are none cities
        model.selectedAreaTypes = [.hokkaido]
        model.favoriteCityIds = []
        filteredList = model.filteringCityDataList(isFavoriteFilter: false)
        XCTAssertEqual(filteredList.count, 1)
        
        // when isFavariteFilter is false
        // when selected none areas
        // when favoriteCityIds are some cities
        model.selectedAreaTypes = [.hokkaido]
        model.favoriteCityIds = ["016010", "020010"]
        filteredList = model.filteringCityDataList(isFavoriteFilter: false)
        XCTAssertEqual(filteredList.count, 1)
        
        // when isFavariteFilter is false
        // when selected some areas
        // when favoriteCityIds are all cities
        model.selectedAreaTypes = [.hokkaido]
        model.favoriteCityIds = makeAllCitiyIds()
        filteredList = model.filteringCityDataList(isFavoriteFilter: false)
        XCTAssertEqual(filteredList.count, 1)
        
        // when isFavariteFilter is false
        // when selected some areas
        // when favoriteCityIds are none cities
        model.selectedAreaTypes = [.hokkaido]
        model.favoriteCityIds = []
        filteredList = model.filteringCityDataList(isFavoriteFilter: false)
        XCTAssertEqual(filteredList.count, 1)
        
        // when isFavariteFilter is false
        // when selected some areas
        // when favoriteCityIds are some cities
        model.selectedAreaTypes = [.hokkaido]
        model.favoriteCityIds = ["016010", "020010"]
        filteredList = model.filteringCityDataList(isFavoriteFilter: false)
        XCTAssertEqual(filteredList.count, 1)
    }
    
    private func makeAllCitiyIds() -> [String] {
        let model = PrefectureListModel()
        let cityDataList = model.loadCityDataList()
        return cityDataList.map { $0.cityId }
    }
}
