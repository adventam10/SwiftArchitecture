//
//  WeatherInterface.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/05.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

// MARK: - view
protocol WeatherView: class {
    func reloadView(forecasts: [Forecast]?, dateFormatter: DateFormatter)
}

// MARK: - presenter
protocol WeatherPresentaion: class {
    func viewDidLoad()
    func didTapRefreshButton(_ button: UIBarButtonItem)
}

// MARK: - interactor
protocol WeatherUsecase: class {
    func requestWeather(cityId: String)
}

protocol WeatherInteractorDelegate: class {
    func interactor(_ interactor: WeatherUsecase, didSuccess weather: Weather)
    func interactor(_ interactor: WeatherUsecase, didFailWithMessage message: String)
}

// MARK: - router
protocol WeatherWireframe: class {
    func showSingleButtonAlert(title: String, message: String, action: (() -> Void)?)
}

