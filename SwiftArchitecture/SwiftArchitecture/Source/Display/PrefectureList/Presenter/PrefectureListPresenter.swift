//
//  PrefectureListPresenter.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/04.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import SVProgressHUD

class PrefectureListPresenter {
    private weak var view: PrefectureListView?
    private let interactor: PrefectureListUsecase
    private let router: PrefectureListWireframe
    
    var tableDataList = [CityData]()
    var cityDataList = [CityData]()
    var selectedAreaTypes = [Area]()
    var favoriteCityIds = [String]()
    var isFavoriteFilter = false
        
    init(view: PrefectureListView, interactor: PrefectureListUsecase, router: PrefectureListWireframe) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    private func reloadView() {
        tableDataList = interactor.setupTableDataList(cityDataList: cityDataList,
                                                      selectedAreaTypes: selectedAreaTypes,
                                                      isFavoriteFilter: isFavoriteFilter,
                                                      favoriteCityIds: favoriteCityIds)
        view?.reloadView(isFavoriteFilter: isFavoriteFilter, isTableDataNone: tableDataList.isEmpty)
    }
}

extension PrefectureListPresenter: PrefectureListPresentaion {
    func viewDidLoad() {
        cityDataList = interactor.loadCityDataList()
        favoriteCityIds = interactor.loadFavoriteList()
        tableDataList = interactor.setupTableDataList(cityDataList: cityDataList,
                                                      selectedAreaTypes: selectedAreaTypes,
                                                      isFavoriteFilter: isFavoriteFilter,
                                                      favoriteCityIds: favoriteCityIds)
        view?.reloadView(isFavoriteFilter: isFavoriteFilter, isTableDataNone: tableDataList.isEmpty)
    }
    
    func didTapFavoriteButton(_ button: UIButton) {
        isFavoriteFilter = !isFavoriteFilter
        reloadView()
    }
    
    func didTapAreaFilterButton(_ button: UIButton) {
        router.showAreaFilterViewController(button: button, selectedAreaTypes: selectedAreaTypes)
    }
    
    func didSelectAreaTypes(_  areaTypes: [Area]) {
        selectedAreaTypes = areaTypes
        reloadView()
    }
    
    func didTapFavoriteButton(_ button: UIButton, indexPath: IndexPath) {
        let cityId = tableDataList[indexPath.row].cityId
        if let index = favoriteCityIds.index(of: cityId) {
            favoriteCityIds.remove(at: index)
        } else {
            favoriteCityIds.append(cityId)
        }
        interactor.saveFavoriteList(cityIds: favoriteCityIds)
        reloadView()
    }
    
    func didSelectCityData(at indexPath: IndexPath) {
        SVProgressHUD.show()
        interactor.requestWeather(cityData: tableDataList[indexPath.row])
    }
}

extension PrefectureListPresenter: PrefectureListInteractorDelegate {
    func interactor(_ interactor: PrefectureListUsecase, didSuccess weather: Weather, cityData: CityData) {
        SVProgressHUD.dismiss()
        router.showWeatherViewController(weather: weather, cityData: cityData)
    }
    
    func interactor(_ interactor: PrefectureListUsecase, didFailWithMessage message: String) {
        SVProgressHUD.dismiss()
        router.showSingleButtonAlert(title: "", message: message, action: nil)
    }
}
