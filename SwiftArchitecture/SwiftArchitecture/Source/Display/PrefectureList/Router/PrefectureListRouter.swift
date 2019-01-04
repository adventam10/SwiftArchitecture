//
//  PrefectureListRouter.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/04.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

class PrefectureListRouter {
    weak var viewController: UIViewController?
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func assembleModules(view: PrefectureListViewController) {
        let interactor = PrefectureListInteractor()
        let router = PrefectureListRouter(viewController: view)
        let presenter = PrefectureListPresenter(view: view, interactor: interactor, router: router)
        
        interactor.delegate = presenter
        view.presenter = presenter
    }
}

extension PrefectureListRouter: PrefectureListWireframe {
    func showAreaFilterViewController(button: UIButton, selectedAreaTypes: [Area]) {
        let nextViewController = AreaFilterRouter.assembleModules(selectedAreaTypes: selectedAreaTypes) as! AreaFilterViewController
        nextViewController.delegate = viewController as! PrefectureListViewController
        viewController?.showPopover(viewController: nextViewController,
                                    sourceView: button,
                                    direction: .up,
                                    delegate: viewController as! PrefectureListViewController)
    }
    
    func showWeatherViewController(weather: Weather, cityData: CityData) {
        let nextViewController = WeatherRouter.assembleModules(weather: weather, cityData: cityData)
        viewController?.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func showSingleButtonAlert(title: String, message: String, action: (() -> Void)?) {
        UIAlertController.showAlert(viewController: viewController!,
                                    title: title,
                                    message: message,
                                    buttonTitle: "閉じる",
                                    buttonAction: action)
    }
}
