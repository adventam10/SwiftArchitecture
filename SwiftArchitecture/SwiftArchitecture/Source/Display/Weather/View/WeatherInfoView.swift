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
        func getFont() -> UIFont {
            switch self {
            case .large:
                return UIFont.systemFont(ofSize: 17)
            case .small:
                return UIFont.systemFont(ofSize: 14)
            }
        }
        func getHeight() -> CGFloat {
            switch self {
            case .large:
                return 20
            case .small:
                return 15
            }
        }
    }
    let largeFont = UIFont.systemFont(ofSize: 17)
    let smallFont = UIFont.systemFont(ofSize: 15)
    var viewType = ViewType.large {
        didSet {
            let font = viewType.getFont()
            dateLabel.font = font
            subDateLabel.font = font
            telopLabel.font = font
            maxCelsiusLabel.font = font
            minCelsiusLabel.font = font
            maxCelsiusTitleLabel.font = font
            minCelsiusTitleLabel.font = font
            labelHeightConstraint.constant = viewType.getHeight()
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
    private let noImage = R.image.icon_no_image()
    
    func displayView(viewModel: WeatherInfoViewModel) {
        dateLabel.text = viewModel.dateText
        subDateLabel.text = viewModel.subDateLabel
        telopLabel.text = viewModel.telop
        imageView.image = getImage(url: viewModel.imagUrl)
        maxCelsiusLabel.text = viewModel.maxCelsius
        minCelsiusLabel.text = viewModel.minCelsius
    }
    
    private func getImage(url: URL?) -> UIImage? {
        guard let url = url else {
            return noImage
        }
        return UIImage(data: try! Data(contentsOf: url))
    }
}
