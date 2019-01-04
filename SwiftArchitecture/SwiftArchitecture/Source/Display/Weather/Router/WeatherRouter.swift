//
//  WeatherRouter.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/05.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

class WeatherRouter {
    weak var viewController: UIViewController?
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func assembleModules(weather: Weather, cityData: CityData) -> UIViewController {
        let view = WeatherViewController()
        let interactor = WeatherInteractor()
        let router = WeatherRouter(viewController: view)
        let presenter = WeatherPresenter(view: view, interactor: interactor, router: router)
        presenter.cityData = cityData
        presenter.weather = weather
        interactor.delegate = presenter
        view.presenter = presenter
        return view
    }
}

extension WeatherRouter: WeatherWireframe {
    func showSingleButtonAlert(title: String, message: String, action: (() -> Void)?) {
        UIAlertController.showAlert(viewController: viewController!,
                                    title: title,
                                    message: message,
                                    buttonTitle: "閉じる",
                                    buttonAction: action)
    }
}
