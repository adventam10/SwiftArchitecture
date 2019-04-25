//
//  WeatherViewModel.swift
//  SwiftArchitecture
//
//  Created by makoto on 2019/04/24.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift

class WeatherViewModel {
    var weather: MutableProperty<Weather>
    let cityData: CityData
    let dateFormatter :DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "yyyy/MM/dd(E)"
        return df
    }()
    
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
    
    init(weather: Weather, cityData: CityData) {
        self.weather = MutableProperty(weather)
        self.cityData = cityData
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
