//
//  WeatherInfoView.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

final class WeatherInfoView: BaseView {
    
    enum ViewType {
        
        case large
        case small
        var font: UIFont {
            switch self {
            case .large:
                return .systemFont(ofSize: 17)
            case .small:
                return .systemFont(ofSize: 14)
            }
        }
        var height: CGFloat {
            switch self {
            case .large:
                return 20
            case .small:
                return 15
            }
        }
    }

    var viewType = ViewType.large {
        didSet {
            let font = viewType.font
            dateLabel.font = font
            subDateLabel.font = font
            telopLabel.font = font
            maxCelsiusLabel.font = font
            minCelsiusLabel.font = font
            maxCelsiusTitleLabel.font = font
            minCelsiusTitleLabel.font = font
            labelHeightConstraint.constant = viewType.height
        }
    }
    
    @IBOutlet private weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var subDateLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var telopLabel: UILabel!
    @IBOutlet private weak var maxCelsiusLabel: UILabel!
    @IBOutlet private weak var minCelsiusLabel: UILabel!
    @IBOutlet private weak var maxCelsiusTitleLabel: UILabel!
    @IBOutlet private weak var minCelsiusTitleLabel: UILabel!
   
    func displayView(date: String, subDate: String, telop: String,
                     maxCelsius: String, minCelsius: String, image: UIImage?) {
        dateLabel.text = date
        subDateLabel.text = subDate
        telopLabel.text = telop
        imageView.image = image
        maxCelsiusLabel.text = maxCelsius
        minCelsiusLabel.text = minCelsius
    }
}
