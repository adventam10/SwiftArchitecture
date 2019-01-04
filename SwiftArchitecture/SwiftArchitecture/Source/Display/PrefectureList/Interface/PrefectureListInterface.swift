//
//  PrefectureListInterface.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/04.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

// MARK: - view
protocol PrefectureListView: class {
    func reloadView(isFavoriteFilter: Bool, isTableDataNone: Bool)
}

// MARK: - presenter
protocol PrefectureListPresentaion: class {
    func viewDidLoad()
    func didTapFavoriteButton(_ button: UIButton)
    func didTapAreaFilterButton(_ button: UIButton)
    func didSelectAreaTypes(_  areaTypes: [Area])
    func didTapFavoriteButton(_ button: UIButton, indexPath: IndexPath)
    func didSelectCityData(at indexPath: IndexPath)
}

// MARK: - interactor
protocol PrefectureListUsecase: class {
    func setupTableDataList(cityDataList: [CityData],
                            selectedAreaTypes: [Area],
                            isFavoriteFilter: Bool,
                            favoriteCityIds: [String]) -> [CityData]
    func loadCityDataList() -> [CityData]
    func loadFavoriteList() -> [String]
    func saveFavoriteList(cityIds: [String])
    func requestWeather(cityData: CityData)
}

protocol PrefectureListInteractorDelegate: class {
    func interactor(_ interactor: PrefectureListUsecase, didSuccess weather: Weather, cityData: CityData)
    func interactor(_ interactor: PrefectureListUsecase, didFailWithMessage message: String)
}

// MARK: - router
protocol PrefectureListWireframe: class {
    func showAreaFilterViewController(button: UIButton, selectedAreaTypes: [Area])
    func showWeatherViewController(weather: Weather, cityData: CityData)
    func showSingleButtonAlert(title: String, message: String, action: (() -> Void)?)
}
