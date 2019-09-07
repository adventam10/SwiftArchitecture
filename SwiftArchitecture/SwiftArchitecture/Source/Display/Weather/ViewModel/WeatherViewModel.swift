//
//  WeatherViewModel.swift
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

struct WeatherViewModel: Injectable {
    struct Dependency {
        let resolver: AppResolver
        let apiClient: WeatherAPIClient
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
    private let apiClient: WeatherAPIClient
    let cityData: CityData
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        let localeIdentifier = Bundle.main.preferredLocalizations.first!
        formatter.locale = Locale(identifier: localeIdentifier)
        formatter.dateFormat = NSLocalizedString("yyyy/MM/dd(E)", comment: "")
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
    
    func requestWeather(cityId: String) -> SignalProducer<Weather, APIError> {
        return apiClient.send(request: WeatherDetailAPI(cityId: cityId)).observe(on: UIScheduler())
    }
}
