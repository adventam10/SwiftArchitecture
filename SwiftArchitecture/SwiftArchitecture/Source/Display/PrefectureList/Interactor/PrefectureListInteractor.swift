//
//  PrefectureListInteractor.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/04.
//  Copyright © 2019年 am10. All rights reserved.
//

import Foundation

class PrefectureListInteractor {
    private let USER_DEFAULTS_FAVORITES_KEY = "USER_DEFAULTS_FAVORITES_KEY"
    weak var delegate: PrefectureListInteractorDelegate?
}

extension PrefectureListInteractor: PrefectureListUsecase {
    func setupTableDataList(cityDataList: [CityData],
                            selectedAreaTypes: [Area],
                            isFavoriteFilter: Bool,
                            favoriteCityIds: [String]) -> [CityData] {
        var tableDataList = cityDataList
        if !selectedAreaTypes.isEmpty {
            let areaTypes = selectedAreaTypes.map { $0.rawValue }
            tableDataList = tableDataList.filter
                {
                    areaTypes.contains($0.area)
            }
        }
        if !isFavoriteFilter {
            return tableDataList
        }
        if favoriteCityIds.isEmpty {
            tableDataList.removeAll()
            return tableDataList
        }
        tableDataList = tableDataList.filter
            {
                favoriteCityIds.contains($0.cityId)
        }
        return tableDataList
    }
    
    func loadCityDataList() -> [CityData] {
        guard let filePath = Bundle.main.path(forResource: "CityData", ofType: "json") else {
            return [CityData]()
        }
        guard let data = FileManager.default.contents(atPath: filePath) else {
            return [CityData]()
        }
        
        guard let result = try? JSONDecoder().decode(CityDataList.self, from: data) else {
            return [CityData]()
        }
        if let cityDataList = result.cityDataList {
            return cityDataList
        }
        return [CityData]()
    }
    
    func loadFavoriteList() -> [String] {
        if let cityIds = UserDefaults.standard.object(forKey: USER_DEFAULTS_FAVORITES_KEY) as? [String] {
            return cityIds
        }
        return [String]()
    }
    
    func saveFavoriteList(cityIds: [String]) {
        UserDefaults.standard.set(cityIds, forKey: USER_DEFAULTS_FAVORITES_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func requestWeather(cityData: CityData) {
        WeatherInteractor.requestWeather(cityId: cityData.cityId,
                                         success:
            {[weak self] (weather) in
                guard let weakSelf = self else { return }
                weakSelf.delegate?.interactor(weakSelf, didSuccess: weather, cityData: cityData)
            },
                                         failure:
            {[weak self] (message) in
                guard let weakSelf = self else { return }
                weakSelf.delegate?.interactor(weakSelf, didFailWithMessage: message)
        })
    }
}
