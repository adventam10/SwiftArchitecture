//
//  WeatherViewController.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import SVProgressHUD

class WeatherViewController: UIViewController {
    var presenter: WeatherPresenter!
    @IBOutlet private weak var todayView: WeatherInfoView!
    @IBOutlet private weak var tomorrowView: WeatherInfoView!
    @IBOutlet private weak var dayAfterTomorrowView: WeatherInfoView!
    private let noImage = UIImage(named: "icon_no_image")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        todayView.viewType = .large
        tomorrowView.viewType = .small
        dayAfterTomorrowView.viewType = .small
        setupNavigation()
        presenter.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupNavigation() {
        self.navigationItem.title = presenter.cityData.name
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .refresh,
                                                                      target: self,
                                                                      action: #selector(tappedRefreshButton(_:)))
    }
    
    @objc
    private func tappedRefreshButton(_ button: UIBarButtonItem) {
        SVProgressHUD.show()
        presenter.didTapRefreshButton(button)
    }
}

extension WeatherViewController: WeatherView {
    func reloadView(forecasts: [Forecast]?, dateFormatter: DateFormatter) {
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
