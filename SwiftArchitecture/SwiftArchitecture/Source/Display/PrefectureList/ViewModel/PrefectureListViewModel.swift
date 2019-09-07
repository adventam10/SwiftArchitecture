//
//  PrefectureListViewModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/04/24.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation
import DIKit
import ReactiveSwift
import APIClient
import JSONExport

struct PrefectureListViewModel: Injectable {
    struct Dependency {
        let resolver: AppResolver
        let apiClient: WeatherAPIClient
    }

    init(dependency: Dependency) {
        self.dependency = dependency
        self.apiClient = dependency.apiClient
        self.resolver = dependency.resolver
    }
    
    private static let USER_DEFAULTS_FAVORITES_KEY = "USER_DEFAULTS_FAVORITES_KEY" // swiftlint:disable:this identifier_name
    private let dependency: Dependency
    let resolver: AppResolver
    private let apiClient: WeatherAPIClient
    let cityDataList = loadCityDataList()
    var tableDataList = MutableProperty([CityData]())
    var selectedAreaTypes = MutableProperty([Area]())
    var favoriteCityIds = MutableProperty(loadFavoriteList())
    var isFavoriteFilter = MutableProperty(false)
    
    func setupFavoriteList(cityId: String) {
        if let index = favoriteCityIds.value.firstIndex(of: cityId) {
            favoriteCityIds.value.remove(at: index)
        } else {
            favoriteCityIds.value.append(cityId)
        }
        PrefectureListViewModel.saveFavoriteList(cityIds: favoriteCityIds.value)
    }
    
    func setupTableDataList() {
        var dataList = cityDataList
        defer {
            tableDataList.value = dataList
        }
        if !selectedAreaTypes.value.isEmpty {
            let areaTypes = selectedAreaTypes.value.map { $0.rawValue }
            dataList = dataList.filter {
                areaTypes.contains($0.area)
            }
        }
        if !isFavoriteFilter.value {
            return
        }
        if favoriteCityIds.value.isEmpty {
            dataList.removeAll()
            return
        }
        dataList = dataList.filter {
            favoriteCityIds.value.contains($0.cityId)
        }
    }
    
    func makeCellViewModel(index: Int) -> PrefectureListCellViewModel {
        let cityData = tableDataList.value[index]
        return PrefectureListCellViewModel(cityName: cityData.name,
                                           isFavorite: favoriteCityIds.value.contains(cityData.cityId))
    }
    
    func requestWeather(cityId: String) -> SignalProducer<Weather, APIError> {
        return apiClient.send(request: WeatherDetailAPI(cityId: cityId)).observe(on: UIScheduler())
    }

    private static func loadCityDataList() -> [CityData] {
        guard let filePath = R.file.cityDataJson.path(),
            let data = FileManager.default.contents(atPath: filePath),
            let result = try? JSONDecoder().decode(CityDataList.self, from: data) else {
            return [CityData]()
        }
        
        return result.cityDataList!
    }
    
    private static func loadFavoriteList() -> [String] {
        if let cityIds = UserDefaults.standard.object(forKey: USER_DEFAULTS_FAVORITES_KEY) as? [String] {
            return cityIds
        }
        return [String]()
    }
    
    private static func saveFavoriteList(cityIds: [String]) {
        UserDefaults.standard.set(cityIds, forKey: USER_DEFAULTS_FAVORITES_KEY)
        UserDefaults.standard.synchronize()
    }
}
