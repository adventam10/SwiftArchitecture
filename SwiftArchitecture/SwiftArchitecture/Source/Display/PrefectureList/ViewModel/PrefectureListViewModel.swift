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

struct FavoriteState: Injectable {
    enum Key: String {
        case favorites = "USER_DEFAULTS_FAVORITES_KEY"
    }
    struct Dependency {
        let defaults: UserDefaults
    }
    
    init(dependency: Dependency) {
        self.defaults = dependency.defaults
    }
    
    private let defaults: UserDefaults
    var favoriteCityIds: [String] {
        if let cityIds = defaults.object(forKey: Key.favorites.rawValue) as? [String] {
            return cityIds
        }
        return [String]()
    }
    
    func updateFavoriteCityIds(_ cityIds: [String]) {
        defaults.set(cityIds, forKey: Key.favorites.rawValue)
        defaults.synchronize()
    }
    
    func clear() {
        defaults.removeObject(forKey: Key.favorites.rawValue)
        defaults.synchronize()
    }
}

struct PrefectureListViewModel: Injectable {
    struct Dependency {
        let resolver: AppResolver
        let apiClient: WeatherAPIClient
        let favoriteState: FavoriteState
    }

    init(dependency: Dependency) {
        self.dependency = dependency
        self.apiClient = dependency.apiClient
        self.resolver = dependency.resolver
        self.favoriteState = dependency.favoriteState
        self.favoriteCityIds.value = favoriteState.favoriteCityIds
    }
    
    private let dependency: Dependency
    let resolver: AppResolver
    private let apiClient: WeatherAPIClient
    let favoriteState: FavoriteState
    let cityDataList = loadCityDataList()
    var tableDataList = MutableProperty([CityData]())
    var selectedAreaTypes = MutableProperty([Area]())
    var favoriteCityIds = MutableProperty([String]())
    var isFavoriteFilter = MutableProperty(false)
    
    func setupFavoriteList(cityId: String) {
        if let index = favoriteCityIds.value.firstIndex(of: cityId) {
            favoriteCityIds.value.remove(at: index)
        } else {
            favoriteCityIds.value.append(cityId)
        }
    }
    
    func setupTableDataList() {
        var dataList = cityDataList
        defer {
            tableDataList.value = dataList
        }
        if !selectedAreaTypes.value.isEmpty {
            let areaTypes = selectedAreaTypes.value.map { $0.rawValue }
            dataList = dataList.filter { areaTypes.contains($0.area) }
        }
        if !isFavoriteFilter.value {
            return
        }
        if favoriteCityIds.value.isEmpty {
            dataList.removeAll()
            return
        }
        dataList = dataList.filter { favoriteCityIds.value.contains($0.cityId) }
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
        guard let data = try? Data(contentsOf: R.file.cityDataJson()!),
            let result = try? JSONDecoder().decode(CityDataList.self, from: data) else {
            return []
        }
        
        return result.cityDataList!
    }
}
