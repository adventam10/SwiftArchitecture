//
//  UIAlertController+showAlert.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

extension UIViewController {
    class func showAlert(viewController: UIViewController,
                         title: String,
                         message: String,
                         buttonTitle: String,
                         buttonAction: (() -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: buttonTitle,
                                          style: .default,
                                          handler: { _ in
                                            buttonAction?()
        })
        alertController.addAction(defaultAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
