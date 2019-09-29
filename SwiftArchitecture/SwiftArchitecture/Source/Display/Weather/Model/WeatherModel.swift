//
//  WeatherModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import Alamofire

final class WeatherModel {
    
    var weather: Weather!
    var cityData: CityData!
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "yyyy/MM/dd(E)"
        return df
    }()
    
    var today: String {
        return dateFormatter.string(from: Date())
    }
    
    var tomorrow: String {
        return dateFormatter.string(from: Date(timeIntervalSinceNow: 60*60*24))
    }
    
    var dayAfterTomorrow: String {
        return dateFormatter.string(from: Date(timeIntervalSinceNow: 60*60*24*2))
    }
    
    var todayForecast: Forecast? {
        return weather.forecasts?.first
    }
    
    var tomorrowForecast: Forecast? {
        return weather.forecasts?.indices.contains(1) == true ? weather.forecasts?[1] : nil
    }
    
    var dayAfterTomorrowForecast: Forecast? {
        return weather.forecasts?.indices.contains(2) == true ? weather.forecasts?[2] : nil
    }
    
    var todayDateLabel: String {
        return todayForecast?.dateLabel ?? ""
    }
    
    var tomorrowDateLabel: String {
        return tomorrowForecast?.dateLabel ?? ""
    }
    
    var dayAfterTomorrowDateLabel: String {
        return dayAfterTomorrowForecast?.dateLabel ?? ""
    }
    
    var todayTelop: String {
        return todayForecast?.telop ?? ""
    }
    
    var tomorrowTelop: String {
        return todayForecast?.telop ?? ""
    }
    
    var dayAfterTomorrowTelop: String {
        return todayForecast?.telop ?? ""
    }
    
    func getImageData(from forecast: Forecast?) -> Data? {
        guard let forecast = forecast,
            let image = forecast.image,
            !image.url.isEmpty,
            let imageData = try? Data(contentsOf: URL(string: image.url)!) else {
                return nil
        }
        return imageData
    }
    
    func getMaxCelsius(from forecast: Forecast?) -> String {
        guard let forecast = forecast,
            let temperature = forecast.temperature,
            let max = temperature.max,
            !max.celsius.isEmpty else {
                return "-"
        }
        return "\(max.celsius)℃"
    }
    
    func getMinCelsius(from forecast: Forecast?) -> String {
        guard let forecast = forecast,
            let temperature = forecast.temperature,
            let min = temperature.min,
            !min.celsius.isEmpty else {
                return "-"
        }
        return "\(min.celsius)℃"
    }
    
    class func requestWeather(cityId: String,
                              success: @escaping (Weather)->Void,
                              failure: @escaping (String)->Void) {
        Alamofire.request(URL(string: "http://weather.livedoor.com/forecast/webservice/json/v1?city=\(cityId)")!).responseJSON { (dataResponse) in
            DispatchQueue.main.async {
                if let error = dataResponse.error {
                    failure(error.localizedDescription)
                    return
                }
                
                if dataResponse.response?.statusCode != 200 {
                    failure("サーバーと通信できません。")
                    return
                }
                
                guard let data = dataResponse.data else {
                    failure("データなし")
                    return
                }
                
                if let result = try? JSONDecoder().decode(Weather.self, from: data) {
                    success(result)
                    return
                }
                
                failure("JSONパース失敗")
            }
        }
    }
}
