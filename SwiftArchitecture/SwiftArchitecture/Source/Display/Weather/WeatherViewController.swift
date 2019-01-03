//
//  WeatherViewController.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

class WeatherViewController: UIViewController {
    
    var weather: Weather!
    var cityData: CityData!
    
    @IBOutlet private weak var todayDateLabel: UILabel!
    @IBOutlet private weak var todaySubDateLabel: UILabel!
    @IBOutlet private weak var todayImageView: UIImageView!
    @IBOutlet private weak var todayTelopLabel: UILabel!
    @IBOutlet private weak var todayMaxCelsiusLabel: UILabel!
    @IBOutlet private weak var todayMinCelsiusLabel: UILabel!
    
    @IBOutlet private weak var tomorrowDateLabel: UILabel!
    @IBOutlet private weak var tomorrowSubDateLabel: UILabel!
    @IBOutlet private weak var tomorrowImageView: UIImageView!
    @IBOutlet private weak var tomorrowTelopLabel: UILabel!
    @IBOutlet private weak var tomorrowMaxCelsiusLabel: UILabel!
    @IBOutlet private weak var tomorrowMinCelsiusLabel: UILabel!
    
    @IBOutlet private weak var dayAfterTomorrowDateLabel: UILabel!
    @IBOutlet private weak var dayAfterTomorrowSubDateLabel: UILabel!
    @IBOutlet private weak var dayAfterTomorrowImageView: UIImageView!
    @IBOutlet private weak var dayAfterTomorrowTelopLabel: UILabel!
    @IBOutlet private weak var dayAfterTomorrowMaxCelsiusLabel: UILabel!
    @IBOutlet private weak var dayAfterTomorrowMinCelsiusLabel: UILabel!
    
    private let dateFormatter = DateFormatter()
    private let noImage = UIImage(named: "icon_no_image")
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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd(E)"
        displayWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupNavigation() {
        self.navigationItem.title = cityData.name
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .refresh,
                                                                      target: self,
                                                                      action: #selector(tappedRefreshButton(_:)))
    }
    
    @objc
    private func tappedRefreshButton(_ button: UIBarButtonItem) {
        SVProgressHUD.show()
        WeatherViewController.requestWeather(cityId: cityData.cityId,
                                             success:
            {[weak self] (weather) in
                SVProgressHUD.dismiss()
                guard let weakSelf = self else { return }
                weakSelf.weather = weather
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
        displayTodayInfo(forecast: nil)
        displayTomorrowInfo(forecast: nil)
        displayDayAfterTomorrowInfo(forecast: nil)
        guard let forecasts = weather.forecasts else {
            return
        }
        for (index, forecast) in forecasts.enumerated() {
            if index == 0 {
                displayTodayInfo(forecast: forecast)
            } else if index == 1 {
                displayTomorrowInfo(forecast: forecast)
            } else if index == 2 {
                displayDayAfterTomorrowInfo(forecast: forecast)
            }
        }
    }
    
    private func displayTodayInfo(forecast: Forecast?) {
        todaySubDateLabel.text = dateFormatter.string(from: Date())
        todayDateLabel.text = forecast?.dateLabel ?? ""
        todayTelopLabel.text = forecast?.telop ?? ""
        todayImageView.image = getImageFrom(forecast: forecast) ?? noImage
        todayMaxCelsiusLabel.text = getMaxCelsiusFrom(forecast: forecast)
        todayMinCelsiusLabel.text = getMinCelsiusFrom(forecast: forecast)
    }
    
    private func displayTomorrowInfo(forecast: Forecast?) {
        tomorrowSubDateLabel.text = dateFormatter.string(from: Date(timeIntervalSinceNow: 60*60*24))
        tomorrowDateLabel.text = forecast?.dateLabel ?? ""
        tomorrowTelopLabel.text = forecast?.telop ?? ""
        tomorrowImageView.image = getImageFrom(forecast: forecast) ?? noImage
        tomorrowMaxCelsiusLabel.text = getMaxCelsiusFrom(forecast: forecast)
        tomorrowMinCelsiusLabel.text = getMinCelsiusFrom(forecast: forecast)
    }
    
    private func displayDayAfterTomorrowInfo(forecast: Forecast?) {
        dayAfterTomorrowSubDateLabel.text = dateFormatter.string(from: Date(timeIntervalSinceNow: 60*60*24*2))
        dayAfterTomorrowDateLabel.text = forecast?.dateLabel ?? ""
        dayAfterTomorrowTelopLabel.text = forecast?.telop ?? ""
        dayAfterTomorrowImageView.image = getImageFrom(forecast: forecast) ?? noImage
        dayAfterTomorrowMaxCelsiusLabel.text = getMaxCelsiusFrom(forecast: forecast)
        dayAfterTomorrowMinCelsiusLabel.text = getMinCelsiusFrom(forecast: forecast)
    }

    private func getImageFrom(forecast: Forecast?) -> UIImage? {
        guard let forecast = forecast else {
            return nil
        }
        guard let image = forecast.image else {
            return nil
        }
        if image.url.isEmpty {
            return nil
        }
        guard let imageData = try? Data(contentsOf: URL(string: image.url)!) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    
    
    private func getMaxCelsiusFrom(forecast: Forecast?) -> String {
        guard let forecast = forecast else {
            return "-"
        }
        guard let temperature = forecast.temperature else {
            return "-"
        }
        guard let max = temperature.max else {
            return "-"
        }
        if max.celsius.isEmpty {
            return "-"
        }
        return "\(max.celsius)℃"
    }
    
    private func getMinCelsiusFrom(forecast: Forecast?) -> String {
        guard let forecast = forecast else {
            return "-"
        }
        guard let temperature = forecast.temperature else {
            return "-"
        }
        guard let min = temperature.min else {
            return "-"
        }
        if min.celsius.isEmpty {
            return "-"
        }
        return "\(min.celsius)℃"
    }
}
