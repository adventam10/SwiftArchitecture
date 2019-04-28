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

class WeatherViewModel {
    var weather: MutableProperty<Weather>
    let apiClient: APIClient
    let cityData: CityData
    let dateFormatter :DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "yyyy/MM/dd(E)"
        return df
    }()
    
    init(weather: Weather, cityData: CityData, apiClient: APIClient) {
        self.weather = MutableProperty(weather)
        self.cityData = cityData
        self.apiClient = apiClient
    }
    
    func createWeatherInfoViewModel(date: WeatherDate,
                                    forecast: Forecast?) -> WeatherInfoViewModel {
        let targetDate: Date
        switch date {
        case .today:
            targetDate = Date()
        case .tomorrow:
            targetDate = Date(timeIntervalSinceNow: 60*60*24)
        case .dayAfterTomorrow:
            targetDate = Date(timeIntervalSinceNow: 60*60*24*2)
        }
        return WeatherInfoViewModel(forecast: forecast,
                                    dateText: dateFormatter.string(from: targetDate))
    }
}
