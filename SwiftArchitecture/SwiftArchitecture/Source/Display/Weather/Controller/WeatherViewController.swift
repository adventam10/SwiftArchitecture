//
//  WeatherViewController.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import SVProgressHUD

final class WeatherViewController: UIViewController {
    
    let model = WeatherModel()
    private let weatherView = WeatherView()
    private let noImage = UIImage(named: "icon_no_image")
    
    override func loadView() {
        self.view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        displayWeather()
    }

    private func setupNavigation() {
        self.navigationItem.title = model.cityData.name
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .refresh,
                                                                      target: self,
                                                                      action: #selector(tappedRefreshButton(_:)))
    }
    
    @objc private func tappedRefreshButton(_ button: UIBarButtonItem) {
        SVProgressHUD.show()
        WeatherModel.requestWeather(cityId: model.cityData.cityId,
                                    success:
            { [unowned self] weather in
                SVProgressHUD.dismiss()
                self.model.weather = weather
                self.displayWeather()
            },
                                    failure:
            { [unowned self] message in
                SVProgressHUD.dismiss()
                UIAlertController.showAlert(viewController: self,
                                            message: message,
                                            buttonTitle: "閉じる")
        })
    }
    
    private func displayWeather() {
        let todayImage = model.getImageData(from: model.todayForecast).flatMap { UIImage(data: $0) } ?? noImage
        weatherView.displayTodayView(date: model.today,
                                     subDate: model.todayDateLabel,
                                     telop: model.todayTelop,
                                     maxCelsius: model.getMaxCelsius(from: model.todayForecast),
                                     minCelsius: model.getMinCelsius(from: model.todayForecast),
                                     image: todayImage)
        
        let tomorrowImage = model.getImageData(from: model.tomorrowForecast).flatMap { UIImage(data: $0) } ?? noImage
        weatherView.displayTomorrowView(date: model.tomorrow,
                                        subDate: model.tomorrowDateLabel,
                                        telop: model.tomorrowTelop,
                                        maxCelsius: model.getMaxCelsius(from: model.tomorrowForecast),
                                        minCelsius: model.getMinCelsius(from: model.tomorrowForecast),
                                        image: tomorrowImage)
        
        let dayAfterTomorrowImage = model.getImageData(from: model.dayAfterTomorrowForecast).flatMap { UIImage(data: $0) } ?? noImage
        weatherView.displayDayAfterTomorrowView(date: model.dayAfterTomorrow,
                                                subDate: model.dayAfterTomorrowDateLabel,
                                                telop: model.dayAfterTomorrowTelop,
                                                maxCelsius: model.getMaxCelsius(from: model.dayAfterTomorrowForecast),
                                                minCelsius: model.getMinCelsius(from: model.dayAfterTomorrowForecast),
                                                image: dayAfterTomorrowImage)
    }
}
