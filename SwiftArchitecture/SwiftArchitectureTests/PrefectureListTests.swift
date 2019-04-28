//
//  PrefectureListTests.swift
//  SwiftArchitectureTests
//
//  Created by makoto on 2019/04/29.
//  Copyright © 2019 am10. All rights reserved.
//

import XCTest
@testable import SwiftArchitecture

class PrefectureListTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCityDataList() {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        XCTAssertEqual(viewModel.cityDataList.count, 47)
    }
    
    func testTableDataList() {
        var viewModel = patternAllNoCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 47)
        
        viewModel = patternAreaAllCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 47)
        
        viewModel = patternAreaAllCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 47)
        
        viewModel = patternAreaHokkaidoCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 1)
        
        viewModel = patternAreaTohokuCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 6)
        
        viewModel = patternAreaKantoCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 7)
        
        viewModel = patternAreaChubuCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 10)
        
        viewModel = patternAreaKinkiCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 6)
        
        viewModel = patternAreaChugokuCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 5)
        
        viewModel = patternAreaShikokuCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 4)
        
        viewModel = patternAreaKyushuCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 8)
        
        viewModel = patternAreaKantoKinkiShikokuCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 17)
        
        viewModel = patternFavoriteNoCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 0)
        
        viewModel = patternFavoriteHokkaidoOsakaFukushimaCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 3)
        
        viewModel = patternFavoriteHokkaidoOsakaFukushimaNoCheck()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 47)
        
        viewModel = patternFavoriteHokkaidoOsakaFukushima_AreaShikoku_Check()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 0)
        
        viewModel = patternFavoriteHokkaidoOsakaFukushima_AreaKinki_Check()
        viewModel.setupTableDataList()
        XCTAssertEqual(viewModel.tableDataList.value.count, 1)
    }

    private func patternAllNoCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value.removeAll()
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternFavoriteHokkaidoOsakaFukushima_AreaShikoku_Check() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.shikoku]
        viewModel.favoriteCityIds.value = ["016010", "270000", "070010"]
        viewModel.isFavoriteFilter.value = true
        return viewModel
    }
    
    private func patternFavoriteHokkaidoOsakaFukushima_AreaKinki_Check() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.kinki]
        viewModel.favoriteCityIds.value = ["016010", "270000", "070010"]
        viewModel.isFavoriteFilter.value = true
        return viewModel
    }
    
    private func patternFavoriteNoCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value.removeAll()
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = true
        return viewModel
    }
    
    private func patternFavoriteHokkaidoOsakaFukushimaCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value.removeAll()
        viewModel.favoriteCityIds.value = ["016010", "270000", "070010"]
        viewModel.isFavoriteFilter.value = true
        return viewModel
    }
    
    private func patternFavoriteHokkaidoOsakaFukushimaNoCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value.removeAll()
        viewModel.favoriteCityIds.value = ["016010", "270000", "070010"]
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternAreaAllCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.hokkaido, .tohoku, .kanto, .chubu, .kinki, .chugoku, .shikoku, .kyushu]
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternAreaKantoKinkiShikokuCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.kanto, .kinki, .shikoku]
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternAreaHokkaidoCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.hokkaido]
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternAreaTohokuCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.tohoku]
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternAreaKantoCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.kanto]
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternAreaChubuCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.chubu]
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternAreaKinkiCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.kinki]
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternAreaChugokuCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.chugoku]
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternAreaShikokuCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.shikoku]
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
    
    private func patternAreaKyushuCheck() -> PrefectureListViewModel {
        let viewModel = PrefectureListViewModel(dependency: PrefectureListViewModel.Dependency(resolver: AppResolverImpl()))
        viewModel.selectedAreaTypes.value = [.kyushu]
        viewModel.favoriteCityIds.value.removeAll()
        viewModel.isFavoriteFilter.value = false
        return viewModel
    }
}
