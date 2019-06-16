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
        var normalFont: UIFont {
            switch self {
            case .large:
                return .systemFont(ofSize: 17)
            case .small:
                return .systemFont(ofSize: 14)
            }
        }
        var minFont: UIFont {
            switch self {
            case .large:
                return .systemFont(ofSize: 14)
            case .small:
                return .systemFont(ofSize: 10)
            }
        }
        func getFont(height: CGFloat) -> UIFont {
            switch self {
            case .large:
                if height < 250 {
                    return minFont
                } else {
                    return normalFont
                }
            case .small:
                if height < 150 {
                    return minFont
                } else {
                    return normalFont
                }
            }
        }
    }
    
    var viewType = ViewType.large
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var subDateLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var telopLabel: UILabel!
    @IBOutlet private weak var maxCelsiusLabel: UILabel!
    @IBOutlet private weak var minCelsiusLabel: UILabel!
    @IBOutlet private weak var maxCelsiusTitleLabel: UILabel!
    @IBOutlet private weak var minCelsiusTitleLabel: UILabel!
    private let noImage = R.image.icon_no_image()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let font = viewType.getFont(height: self.frame.size.height)
        dateLabel.font = font
        subDateLabel.font = font
        telopLabel.font = font
        maxCelsiusLabel.font = font
        minCelsiusLabel.font = font
        maxCelsiusTitleLabel.font = font
        minCelsiusTitleLabel.font = font
    }
    
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
