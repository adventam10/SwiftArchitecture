//
//  AreaFilterRouter.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/05.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

class AreaFilterRouter {
    weak var viewController: UIViewController?
    
    private init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    static func assembleModules(selectedAreaTypes: [Area]) -> UIViewController {
        let view = AreaFilterViewController()
        let interactor = AreaFilterInteractor()
        let router = AreaFilterRouter(viewController: view)
        let presenter = AreaFilterPresenter(view: view, interactor: interactor, router: router)
        presenter.selectedAreaTypes = selectedAreaTypes
        interactor.delegate = presenter
        view.presenter = presenter
        return view
    }
}

extension AreaFilterRouter: AreaFilterWireframe {
    
}
