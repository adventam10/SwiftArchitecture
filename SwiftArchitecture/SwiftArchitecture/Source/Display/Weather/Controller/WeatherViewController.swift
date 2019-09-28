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
    
    override func loadView() {
        self.view = weatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        displayWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupNavigation() {
        self.navigationItem.title = model.cityData.name
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .refresh,
                                                                      target: self,
                                                                      action: #selector(tappedRefreshButton(_:)))
    }
    
    @objc
    private func tappedRefreshButton(_ button: UIBarButtonItem) {
        SVProgressHUD.show()
        WeatherModel.requestWeather(cityId: model.cityData.cityId,
                                             success:
            {[weak self] (weather) in
                SVProgressHUD.dismiss()
                guard let weakSelf = self else { return }
                weakSelf.model.weather = weather
                weakSelf.displayWeather()
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
    
    private func displayWeather() {
        weatherView.displayView(forecasts: model.weather.forecasts, dateFormatter: model.dateFormatter)
    }
}
