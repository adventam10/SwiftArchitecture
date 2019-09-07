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
    let resolver = AppResolverImpl()
    
    override func spec() {
        describe("makeWeatherInfoViewModelWithDate:forecast method") {
            context("today") {
                context("not nil") {
                    let viewModel = makeViewModel()
                    let forecast = makeForecast(date: "", dateLabel: "", image: nil, telop: "", temperature: nil)
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .today, forecast: forecast)
                    it ("not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
                
                context("nil") {
                    let viewModel = makeViewModel()
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .today, forecast: nil)
                    it ("not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
            }
            
            context("tomorrow") {
                context("not nil") {
                    let viewModel = makeViewModel()
                    let forecast = makeForecast(date: "", dateLabel: "", image: nil, telop: "", temperature: nil)
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .tomorrow, forecast: forecast)
                    it ("not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
                
                context("nil") {
                    let viewModel = makeViewModel()
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .tomorrow, forecast: nil)
                    it ("not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
            }
            
            context("dayAfterTomorrow") {
                context("not nil") {
                    let viewModel = makeViewModel()
                    let forecast = makeForecast(date: "", dateLabel: "", image: nil, telop: "", temperature: nil)
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .dayAfterTomorrow, forecast: forecast)
                    it ("not nil") {
                        expect(infoViewModel).toNot(beNil())
                    }
                }
                
                context("nil") {
                    let viewModel = makeViewModel()
                    let infoViewModel = viewModel.makeWeatherInfoViewModel(date: .dayAfterTomorrow, forecast: nil)
                    it ("not nil") {
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
