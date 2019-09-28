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
    
    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var subDateLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var telopLabel: UILabel!
    @IBOutlet private weak var maxCelsiusLabel: UILabel!
    @IBOutlet private weak var minCelsiusLabel: UILabel!
    @IBOutlet private weak var maxCelsiusTitleLabel: UILabel!
    @IBOutlet private weak var minCelsiusTitleLabel: UILabel!
   
    func displayView(forecast: Forecast?, dateText: String, noImage: UIImage?) {
        dateLabel.text = dateText
        subDateLabel.text = forecast?.dateLabel ?? ""
        telopLabel.text = forecast?.telop ?? ""
        imageView.image = getImageFrom(forecast: forecast) ?? noImage
        maxCelsiusLabel.text = getMaxCelsiusFrom(forecast: forecast)
        minCelsiusLabel.text = getMinCelsiusFrom(forecast: forecast)
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
