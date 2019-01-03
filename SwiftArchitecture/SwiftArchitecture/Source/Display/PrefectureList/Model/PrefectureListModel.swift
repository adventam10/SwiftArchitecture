//
//  PrefectureListModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

class PrefectureListModel {
    let USER_DEFAULTS_FAVORITES_KEY = "USER_DEFAULTS_FAVORITES_KEY"
    var tableDataList = [CityData]()
    var cityDataList = [CityData]()
    var selectedAreaTypes = [AreaFilterModel.Area]()
    var favoriteCityIds = [String]()
    var isFavoriteFilter = false
    
    init() {
        loadCityDataList()
        favoriteCityIds = loadFavoriteList()
        setupTableDataList()
    }
    
    func setupFavoriteList(cityId: String) {
        if let index = favoriteCityIds.index(of: cityId) {
            favoriteCityIds.remove(at: index)
        } else {
            favoriteCityIds.append(cityId)
        }
        saveFavoriteList(cityIds: favoriteCityIds)
    }
    
    func setupTableDataList() {
        tableDataList = cityDataList
        if !selectedAreaTypes.isEmpty {
            let areaTypes = selectedAreaTypes.map { $0.rawValue }
            tableDataList = tableDataList.filter
                {
                    areaTypes.contains($0.area)
            }
        }
        if !isFavoriteFilter {
            return
        }
        if favoriteCityIds.isEmpty {
            tableDataList.removeAll()
            return
        }
        tableDataList = tableDataList.filter
            {
                favoriteCityIds.contains($0.cityId)
        }
    }
    
    private func loadCityDataList() {
        guard let filePath = Bundle.main.path(forResource: "CityData", ofType: "json") else {
            return
        }
        guard let data = FileManager.default.contents(atPath: filePath) else {
            return
        }
        
        guard let result = try? JSONDecoder().decode(CityDataList.self, from: data) else {
            return
        }
        if let cityDataList = result.cityDataList {
            self.cityDataList = cityDataList
        }
    }
    
    private func loadFavoriteList() -> [String] {
        if let cityIds = UserDefaults.standard.object(forKey: USER_DEFAULTS_FAVORITES_KEY) as? [String] {
            return cityIds
        }
        return [String]()
    }
    
    private func saveFavoriteList(cityIds: [String]) {
        UserDefaults.standard.set(cityIds, forKey: USER_DEFAULTS_FAVORITES_KEY)
        UserDefaults.standard.synchronize()
    }
}
