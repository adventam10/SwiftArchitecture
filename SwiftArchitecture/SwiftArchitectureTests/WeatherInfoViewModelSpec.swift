//
//  WeatherInfoViewModelSpec.swift
//  SwiftArchitectureTests
//
//  Created by am10 on 2019/09/07.
//  Copyright © 2019 am10. All rights reserved.
//

import Quick
import Nimble
import JSONExport
@testable import SwiftArchitecture

class WeatherInfoViewModelSpec: QuickSpec {
    
    override func spec() {
        describe("initWithForecast:dateText method") {
            context("when forecast is not nil") {
                let image = makeImage(url: "https://google.com", title: "晴れ", height: 50, width: 50)
                let temperature = makeTemperature(max: makeMax(celsius: "13", fahrenheit: "55.4"),
                                                  min: makeMax(celsius: "3", fahrenheit: "37.4"))
                let forecast = makeForecast(date: "2013-01-30", dateLabel: "today",
                                            image: image, telop: "曇り",
                                            temperature: temperature)
                let viewModel = WeatherInfoViewModel(forecast: forecast, dateText: "2013/01/30")
                it ("is decoadable") {
                    expect(viewModel.dateText).to(equal("2013/01/30"))
                    expect(viewModel.subDateLabel).to(equal("today"))
                    expect(viewModel.telop).to(equal("曇り"))
                    expect(viewModel.imagUrl).to(equal(URL(string: "https://google.com")))
                    expect(viewModel.maxCelsius).to(equal("13℃"))
                    expect(viewModel.minCelsius).to(equal("3℃"))
                }
            }
            
            context("when forecast is nil") {
                let viewModel = WeatherInfoViewModel(forecast: nil, dateText: "2013/01/30")
                it ("is decoadable") {
                    expect(viewModel.dateText).to(equal("2013/01/30"))
                    expect(viewModel.subDateLabel).to(beEmpty())
                    expect(viewModel.telop).to(beEmpty())
                    expect(viewModel.imagUrl).to(beNil())
                    expect(viewModel.maxCelsius).to(equal("-"))
                    expect(viewModel.minCelsius).to(equal("-"))
                }
            }
        }
    }
}
