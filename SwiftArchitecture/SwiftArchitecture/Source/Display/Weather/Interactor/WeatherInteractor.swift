//
//  WeatherInteractor.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/05.
//  Copyright © 2019年 am10. All rights reserved.
//

import Foundation
import Alamofire

class WeatherInteractor {
    weak var delegate: WeatherInteractorDelegate?
    static func requestWeather(cityId: String,
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

extension WeatherInteractor: WeatherUsecase {
    func requestWeather(cityId: String) {
        WeatherInteractor.requestWeather(cityId: cityId,
                                         success:
            {[weak self] (weather) in
                guard let weakSelf = self else { return }
                weakSelf.delegate?.interactor(weakSelf, didSuccess: weather)
            },
                                         failure:
            {[weak self] (message) in
                guard let weakSelf = self else { return }
                weakSelf.delegate?.interactor(weakSelf, didFailWithMessage: message)
        })
    }
}
