//
//  WeatherPresenter.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/05.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import SVProgressHUD

class WeatherPresenter {
    private weak var view: WeatherView?
    private let interactor: WeatherUsecase
    private let router: WeatherWireframe
    
    var weather: Weather!
    var cityData: CityData!
    let dateFormatter = DateFormatter()
    
    init(view: WeatherView, interactor: WeatherUsecase, router: WeatherWireframe) {
        self.view = view
        self.interactor = interactor
        self.router = router
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd(E)"
    }
}

extension WeatherPresenter: WeatherPresentaion {
    func viewDidLoad() {
        view?.reloadView(forecasts: weather.forecasts, dateFormatter: dateFormatter)
    }
    
    func didTapRefreshButton(_ button: UIBarButtonItem) {
        interactor.requestWeather(cityId: cityData.cityId)
    }
}

extension WeatherPresenter: WeatherInteractorDelegate {
    func interactor(_ interactor: WeatherUsecase, didSuccess weather: Weather) {
        SVProgressHUD.dismiss()
        self.weather = weather
        view?.reloadView(forecasts: weather.forecasts, dateFormatter: dateFormatter)
    }
    
    func interactor(_ interactor: WeatherUsecase, didFailWithMessage message: String) {
        SVProgressHUD.dismiss()
        router.showSingleButtonAlert(title: "", message: message, action: nil)
    }
}
