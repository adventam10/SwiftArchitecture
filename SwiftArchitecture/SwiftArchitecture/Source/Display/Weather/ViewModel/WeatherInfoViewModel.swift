//
//  WeatherInfoViewModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/04/25.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation
import JSONExport

enum WeatherDate: Int {
    case today = 0
    case tomorrow
    case dayAfterTomorrow
}

struct WeatherInfoViewModel {
    let dateText: String
    let subDateLabel: String
    let telop: String
    let imagUrl: URL?
    let maxCelsius: String
    let minCelsius: String
    init(forecast: Forecast?, dateText: String) {
        self.dateText = dateText
        subDateLabel = NSLocalizedString(forecast?.dateLabel ?? "", comment: "")
        telop = forecast?.telop ?? ""
        imagUrl = WeatherInfoViewModel.getImageUrlFrom(forecast: forecast)
        maxCelsius = WeatherInfoViewModel.getMaxCelsiusFrom(forecast: forecast)
        minCelsius = WeatherInfoViewModel.getMinCelsiusFrom(forecast: forecast)
    }
    
    private static func getImageUrlFrom(forecast: Forecast?) -> URL? {
        guard let forecast = forecast,
            let image = forecast.image else {
            return nil
        }
        if image.url.isEmpty {
            return nil
        }
        
        return URL(string: image.url)!
    }
    
    private static func getMaxCelsiusFrom(forecast: Forecast?) -> String {
        guard let forecast = forecast,
            let temperature = forecast.temperature,
            let max = temperature.max else {
            return "-"
        }
        if max.celsius.isEmpty {
            return "-"
        }
        return "\(max.celsius)℃"
    }
    
    private static func getMinCelsiusFrom(forecast: Forecast?) -> String {
        guard let forecast = forecast,
            let temperature = forecast.temperature,
            let min = temperature.min else {
                return "-"
        }
        if min.celsius.isEmpty {
            return "-"
        }
        return "\(min.celsius)℃"
    }
}
