//
//  WeatherViewController.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import SVProgressHUD
import ReactiveSwift

class WeatherViewController: UIViewController {
    var viewModel: WeatherViewModel!
    @IBOutlet private weak var todayView: WeatherInfoView!
    @IBOutlet private weak var tomorrowView: WeatherInfoView!
    @IBOutlet private weak var dayAfterTomorrowView: WeatherInfoView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        todayView.viewType = .large
        tomorrowView.viewType = .small
        dayAfterTomorrowView.viewType = .small
        setupNavigation()
        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupNavigation() {
        self.navigationItem.title = viewModel.cityData.name
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh,
                                                                 target: self,
                                                                 action: #selector(tappedRefreshButton(_:)))
    }
    
    private func bind() {
        viewModel.weather.producer.startWithValues  { [unowned self] weather in
            self.displayView(forecasts: weather.forecasts)
        }
    }
    
    // MARK:- Button Action
    @objc
    private func tappedRefreshButton(_ button: UIBarButtonItem) {
        SVProgressHUD.show()
        WeatherViewModel.requestWeather(cityId: viewModel.cityData.cityId,
                                             success:
            {[weak self] (weather) in
                SVProgressHUD.dismiss()
                guard let weakSelf = self else { return }
                weakSelf.viewModel.weather.value = weather
            },
                                             failure:
            {[weak self] (message) in
                SVProgressHUD.dismiss()
                guard let weakSelf = self else { return }
                UIAlertController.showAlert(viewController: weakSelf,
                                            title: "",
                                            message: message,
                                            buttonTitle: "閉じる",
                                            buttonAction: nil)
        })
    }
    
    // MARK:- Display
    private func displayView(date: WeatherDate, forecast: Forecast?) {
        let infoView: WeatherInfoView
        switch date {
        case .today:
            infoView = todayView
        case .tomorrow:
            infoView = tomorrowView
        case .dayAfterTomorrow:
            infoView = dayAfterTomorrowView
        }
        let model = viewModel.createWeatherInfoViewModel(date: date,
                                                         forecast: forecast)
        infoView.displayView(viewModel: model)
    }
    
    private func displayView(forecasts: [Forecast]?) {
        displayView(date: .today, forecast: nil)
        displayView(date: .tomorrow, forecast: nil)
        displayView(date: .dayAfterTomorrow, forecast: nil)
        guard let forecasts = forecasts else {
            return
        }
        for (index, forecast) in forecasts.enumerated() {
            guard let date = WeatherDate(rawValue: index) else {
                return
            }
            displayView(date: date, forecast: forecast)
        }
    }
}
