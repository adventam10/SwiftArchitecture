//
//  PrefectureListModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

final class PrefectureListModel {
    
    let USER_DEFAULTS_FAVORITES_KEY = "USER_DEFAULTS_FAVORITES_KEY"
    var tableDataList = [CityData]()
    var cityDataList = [CityData]()
    var selectedAreaTypes = [AreaFilterModel.Area]()
    var favoriteCityIds = [String]()
    var isFavoriteFilter = false
    
    init() {
        self.cityDataList = loadCityDataList()
        self.favoriteCityIds = loadFavoriteList()
        self.tableDataList = filteringCityDataList(isFavoriteFilter: isFavoriteFilter)
    }
    
    private func filteringCityDataList(_ cityDataList: [CityData],
                                       byAreaTypes areaTypes: [AreaFilterModel.Area]) -> [CityData] {
        if areaTypes.isEmpty {
            return cityDataList
        }
        let areas = areaTypes.map { $0.rawValue }
        return cityDataList.filter { areas.contains($0.area) }
    }
    
    private func filteringCityDataList(_ cityDataList: [CityData],
                                       byFavoriteCityIds favoriteCityIds: [String]) -> [CityData] {
        if favoriteCityIds.isEmpty {
            return []
        }
        return cityDataList.filter { favoriteCityIds.contains($0.cityId) }
    }
    
    func filteringCityDataList(isFavoriteFilter: Bool) -> [CityData] {
        let filteredDataList = filteringCityDataList(cityDataList, byAreaTypes: selectedAreaTypes)
        return isFavoriteFilter ? filteringCityDataList(filteredDataList, byFavoriteCityIds: favoriteCityIds) : filteredDataList
    }
    
    func loadCityDataList() -> [CityData] {
        guard let url = Bundle.main.url(forResource: "CityData", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let result = try? JSONDecoder().decode(CityDataList.self, from: data) else {
                return []
        }
        return result.cityDataList ?? []
    }
    
    func loadFavoriteList() -> [String] {
        if let cityIds = UserDefaults.standard.object(forKey: USER_DEFAULTS_FAVORITES_KEY) as? [String] {
            return cityIds
        }
        return []
    }
    
    func saveFavoriteList(_ cityIds: [String]) {
        UserDefaults.standard.set(cityIds, forKey: USER_DEFAULTS_FAVORITES_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func requestWeather(cityId: String,
                        completion: @escaping (Result<Weather, APIError>) -> Void) {
        APIClient.shared.requestWeather(cityId: cityId, completion: completion)
    }
}
