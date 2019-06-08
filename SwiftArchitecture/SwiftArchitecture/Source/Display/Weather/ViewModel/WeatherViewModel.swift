//
//  WeatherViewModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/04/24.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift
import DIKit

struct WeatherViewModel: Injectable {
    struct Dependency {
        let resolver: AppResolver
        let apiClient: APIClient
        let weather: Weather
        let cityData: CityData
    }
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.apiClient = dependency.apiClient
        self.weather = MutableProperty(dependency.weather)
        self.cityData = dependency.cityData
    }
    
    private let dependency: Dependency
    var weather: MutableProperty<Weather>
    let apiClient: APIClient
    let cityData: CityData
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "yyyy/MM/dd(E)"
        return formatter
    }()
    
    func createWeatherInfoViewModel(date: WeatherDate,
                                    forecast: Forecast?) -> WeatherInfoViewModel {
        let targetDate: Date
        switch date {
        case .today:
            targetDate = Date()
        case .tomorrow:
            targetDate = Date(timeIntervalSinceNow: 60 * 60 * 24)
        case .dayAfterTomorrow:
            targetDate = Date(timeIntervalSinceNow: 60 * 60 * 24 * 2)
        }
        return WeatherInfoViewModel(forecast: forecast,
                                    dateText: dateFormatter.string(from: targetDate))
    }
}
