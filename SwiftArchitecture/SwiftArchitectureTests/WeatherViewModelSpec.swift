//
//  WeatherViewModelSpec.swift
//  SwiftArchitectureTests
//
//  Created by am10 on 2019/09/07.
//  Copyright © 2019 am10. All rights reserved.
//

import Quick
import Nimble
import JSONExport
@testable import SwiftArchitecture

class WeatherViewModelSpec: QuickSpec {
    let resolver = TestResolver()
    
    override func spec() {
        describe("makeWeatherInfoViewModelWithDate:forecast method") {
            context("when date is today") {
                context("when forecast is not nil") {
                    let viewModel = makeViewModel()
                    let forecast = makeForecast(date: "", dateLabel: "", image: nil, telop: "", temperature: nil)
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .today, forecast: forecast)
                    it ("returns not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
                
                context("when forecast is nil") {
                    let viewModel = makeViewModel()
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .today, forecast: nil)
                    it ("returns not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
            }
            
            context("when date is tomorrow") {
                context("when forecast is not nil") {
                    let viewModel = makeViewModel()
                    let forecast = makeForecast(date: "", dateLabel: "", image: nil, telop: "", temperature: nil)
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .tomorrow, forecast: forecast)
                    it ("returns not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
                
                context("when forecast is nil") {
                    let viewModel = makeViewModel()
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .tomorrow, forecast: nil)
                    it ("returns not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
            }
            
            context("when date is dayAfterTomorrow") {
                context("when forecast is not nil") {
                    let viewModel = makeViewModel()
                    let forecast = makeForecast(date: "", dateLabel: "", image: nil, telop: "", temperature: nil)
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .dayAfterTomorrow, forecast: forecast)
                    it ("returns not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
                
                context("when forecast is nil") {
                    let viewModel = makeViewModel()
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .dayAfterTomorrow, forecast: nil)
                    it ("returns not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
            }
        }
    }
    
    private func makeViewModel() -> WeatherViewModel {
        let text = """
{ "cityId": "270000", "name": "大阪", "area": 4 }
"""
        let weather = makeWeather(link: "", title: "", copyright: nil, descriptionField: nil,
                                  publicTime: "", location: nil, forecast: nil, pinpointLocation: nil)
        let cityData = try! JSONDecoder().decode(CityData.self, from: text.data(using: .utf8)!)
        let viewModel = resolver.resolveWeatherViewModel(weather: weather!, cityData: cityData)
        return viewModel
    }
}
