//
//  WeatherView.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

final class WeatherView: BaseView {
    
    @IBOutlet private weak var todayView: WeatherInfoView!
    @IBOutlet private weak var tomorrowView: WeatherInfoView!
    @IBOutlet private weak var dayAfterTomorrowView: WeatherInfoView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        todayView.viewType = .large
        tomorrowView.viewType = .small
        dayAfterTomorrowView.viewType = .small
    }
    
    func displayTodayView(date: String, subDate: String, telop: String,
                          maxCelsius: String, minCelsius: String, image: UIImage?) {
        todayView.displayView(date: date, subDate: subDate, telop: telop,
                              maxCelsius: maxCelsius, minCelsius: minCelsius, image: image)
    }
    
    func displayTomorrowView(date: String, subDate: String, telop: String,
                             maxCelsius: String, minCelsius: String, image: UIImage?) {
        tomorrowView.displayView(date: date, subDate: subDate, telop: telop,
                                 maxCelsius: maxCelsius, minCelsius: minCelsius, image: image)
    }
    
    func displayDayAfterTomorrowView(date: String, subDate: String, telop: String,
                                     maxCelsius: String, minCelsius: String, image: UIImage?) {
        dayAfterTomorrowView.displayView(date: date, subDate: subDate, telop: telop,
                                         maxCelsius: maxCelsius, minCelsius: minCelsius, image: image)
    }
}
