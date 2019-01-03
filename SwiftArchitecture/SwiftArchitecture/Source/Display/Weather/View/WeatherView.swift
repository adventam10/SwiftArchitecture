//
//  WeatherView.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

class WeatherView: BaseView {
    @IBOutlet private weak var todayView: WeatherInfoView!
    @IBOutlet private weak var tomorrowView: WeatherInfoView!
    @IBOutlet private weak var dayAfterTomorrowView: WeatherInfoView!
    private let noImage = UIImage(named: "icon_no_image")

    override func layoutSubviews() {
        super.layoutSubviews()
        todayView.viewType = .large
        tomorrowView.viewType = .small
        dayAfterTomorrowView.viewType = .small
    }
    
    func displayView(forecasts: [Forecast]?, dateFormatter: DateFormatter) {
        todayView.displayView(forecast: nil,
                              dateText: dateFormatter.string(from: Date()),
                              noImage: noImage)
        tomorrowView.displayView(forecast: nil,
                                 dateText: dateFormatter.string(from: Date(timeIntervalSinceNow: 60*60*24)),
                                 noImage: noImage)
        dayAfterTomorrowView.displayView(forecast: nil,
                                         dateText: dateFormatter.string(from: Date(timeIntervalSinceNow: 60*60*24*2)),
                                         noImage: noImage)
        guard let forecasts = forecasts else {
            return
        }
        for (index, forecast) in forecasts.enumerated() {
            if index == 0 {
                todayView.displayView(forecast: forecast,
                                      dateText: dateFormatter.string(from: Date()),
                                      noImage: noImage)
            } else if index == 1 {
                tomorrowView.displayView(forecast: forecast,
                                         dateText: dateFormatter.string(from: Date(timeIntervalSinceNow: 60*60*24)),
                                         noImage: noImage)
            } else if index == 2 {
                dayAfterTomorrowView.displayView(forecast: forecast,
                                                 dateText: dateFormatter.string(from: Date(timeIntervalSinceNow: 60*60*24*2)),
                                                 noImage: noImage)
            }
        }
    }
}
