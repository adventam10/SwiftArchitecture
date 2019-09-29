//
//  WeatherModelTests.swift
//  SwiftArchitectureTests
//
//  Created by makoto on 2019/09/29.
//  Copyright © 2019 am10. All rights reserved.
//

import XCTest
@testable import SwiftArchitecture

final class WeatherModelTests: XCTestCase {
    
    let dateFormatter: DateFormatter = {
        var df = DateFormatter()
        df.locale = Locale(identifier: "ja_JP")
        df.dateFormat = "yyyy/MM/dd(E)"
        return df
    }()
    let weatherFactory = WeateherFactory()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testToday() {
        let model = WeatherModel()
        XCTAssertEqual(model.today, dateFormatter.string(from: Date()))
    }
    
    func testTomorrow() {
        let model = WeatherModel()
        XCTAssertEqual(model.tomorrow, dateFormatter.string(from: Date(timeIntervalSinceNow: 60*60*24)))
    }
    
    func testDayAfterTomorrow() {
        let model = WeatherModel()
        XCTAssertEqual(model.dayAfterTomorrow, dateFormatter.string(from: Date(timeIntervalSinceNow: 60*60*24*2)))
    }
    
    func testTodayForecast() {
        let model = WeatherModel()
        // when forecasts is empty
        model.weather = makeEmptyForecastsWeather()
        XCTAssertNil(model.todayForecast)
        
        // when forecasts count is greater than or equal to 1
        model.weather = makeWeather()
        XCTAssertNotNil(model.todayForecast)
    }
    
    func testTomorrowForecast() {
        let model = WeatherModel()
        // when forecasts is less than 2
        model.weather = makeEmptyForecastsWeather()
        XCTAssertNil(model.tomorrowForecast)
        
        // when forecasts count is greater than or equal to 2
        model.weather = makeWeather()
        XCTAssertNotNil(model.tomorrowForecast)
    }
    
    func testDayAfterTomorrowForecast() {
        let model = WeatherModel()
        // when forecasts is less than 3
        model.weather = makeEmptyForecastsWeather()
        XCTAssertNil(model.dayAfterTomorrowForecast)
        
        // when forecasts count is greater than or equal to 3
        model.weather = makeWeather()
        XCTAssertNotNil(model.dayAfterTomorrowForecast)
    }
    
    func testTodayTelop() {
        let model = WeatherModel()
        // when first forecasts telop is nil
        model.weather = makeEmptyForecastsWeather()
        XCTAssertEqual(model.todayTelop, "")
        
        // when first forecasts telop is not nil
        model.weather = makeWeather()
        XCTAssertEqual(model.todayTelop, "曇のち雨")
    }
    
    func testTomorrowTelop() {
        let model = WeatherModel()
        // when second forecasts telop is nil
        model.weather = weatherFactory.makeWeather(forecasts: [makeForecast(), makeForecast(), makeForecast()])
        XCTAssertEqual(model.tomorrowTelop, "")
        
        // when second forecasts telop is not nil
        model.weather = makeWeather()
        XCTAssertEqual(model.tomorrowTelop, "曇時々雨")
    }
    
    func testDayAfterTomorrowTelop() {
        let model = WeatherModel()
        // when third forecasts telop is nil
        model.weather = weatherFactory.makeWeather(forecasts: [makeForecast(), makeForecast(), makeForecast()])
        XCTAssertEqual(model.dayAfterTomorrowTelop, "")
        
        // when third forecasts telop is not nil
        model.weather = makeWeather()
        XCTAssertEqual(model.dayAfterTomorrowTelop, "曇時々雨")
    }
    
    func testTodayDateLabel() {
        let model = WeatherModel()
        // when first forecasts dateLabel is nil
        model.weather = weatherFactory.makeWeather(forecasts: [makeForecast(), makeForecast(), makeForecast()])
        XCTAssertEqual(model.todayDateLabel, "")
        
        // when first forecasts dateLabel is not nil
        model.weather = makeWeather()
        XCTAssertEqual(model.todayDateLabel, "今日")
    }
    
    func testTomorrowDateLabel() {
        let model = WeatherModel()
        // when second forecasts dateLabel is nil
        model.weather = weatherFactory.makeWeather(forecasts: [makeForecast(), makeForecast(), makeForecast()])
        XCTAssertEqual(model.tomorrowDateLabel, "")
        
        // when second forecasts dateLabel is not nil
        model.weather = makeWeather()
        XCTAssertEqual(model.tomorrowDateLabel, "明日")
    }
    
    func testDayAfterTomorrowDateLabel() {
        let model = WeatherModel()
        // when third forecasts dateLabel is nil
        model.weather = weatherFactory.makeWeather(forecasts: [makeForecast(), makeForecast(), makeForecast()])
        XCTAssertEqual(model.dayAfterTomorrowDateLabel, "")
        
        // when third forecasts dateLabel is not nil
        model.weather = makeWeather()
        XCTAssertEqual(model.dayAfterTomorrowDateLabel, "明後日")
    }
    
    func testGetMinCelsius() {
        let model = WeatherModel()
        // when forecast is nil
        XCTAssertEqual(model.getMinCelsius(from: nil), "-")
        // when temperature is nil
        var forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: nil,
                                                   telop: "", temperature: nil)
        XCTAssertEqual(model.getMinCelsius(from: forecast), "-")
        
        // when min is nil
        var temperature = weatherFactory.makeTemperature(max: nil, min: nil)
        forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: nil,
                                               telop: "", temperature: temperature)
        XCTAssertEqual(model.getMinCelsius(from: forecast), "-")
        
        // when min celsius is empty string
        var min = weatherFactory.makeMax(celsius: "", fahrenheit: "")
        temperature = weatherFactory.makeTemperature(max: nil, min: min)
        forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: nil,
                                               telop: "", temperature: temperature)
        XCTAssertEqual(model.getMinCelsius(from: forecast), "-")
        
        // when min celsius is not empty string
        min = weatherFactory.makeMax(celsius: "20", fahrenheit: "")
        temperature = weatherFactory.makeTemperature(max: nil, min: min)
        forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: nil,
                                               telop: "", temperature: temperature)
        XCTAssertEqual(model.getMinCelsius(from: forecast), "20℃")
    }
    
    func testGetMaxCelsius() {
        let model = WeatherModel()
        // when forecast is nil
        XCTAssertEqual(model.getMaxCelsius(from: nil), "-")
        
        // when temperature is nil
        var forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: nil,
                                                   telop: "", temperature: nil)
        XCTAssertEqual(model.getMaxCelsius(from: forecast), "-")
        
        // when max is nil
        var temperature = weatherFactory.makeTemperature(max: nil, min: nil)
        forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: nil,
                                               telop: "", temperature: temperature)
        XCTAssertEqual(model.getMaxCelsius(from: forecast), "-")
        
        // when max celsius is empty string
        var max = weatherFactory.makeMax(celsius: "", fahrenheit: "")
        temperature = weatherFactory.makeTemperature(max: max, min: nil)
        forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: nil,
                                               telop: "", temperature: temperature)
        XCTAssertEqual(model.getMaxCelsius(from: forecast), "-")
        
        // when max celsius is not empty string
        max = weatherFactory.makeMax(celsius: "30", fahrenheit: "")
        temperature = weatherFactory.makeTemperature(max: max, min: nil)
        forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: nil,
                                               telop: "", temperature: temperature)
        XCTAssertEqual(model.getMaxCelsius(from: forecast), "30℃")
    }
    
    func testGetImageData() {
        let model = WeatherModel()
        // when forecast is nil
        XCTAssertNil(model.getImageData(from: nil))
        
        // when image is nil
        var forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: nil,
                                                   telop: "", temperature: nil)
        XCTAssertNil(model.getImageData(from: forecast))
        
        // when url is empty string
        var image = weatherFactory.makeImage(url: "", title: "", height: 0, width: 0)
        forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: image,
                                               telop: "", temperature: nil)
        XCTAssertNil(model.getImageData(from: nil))
        
        // when url is not empty string
        let url = Bundle(for: PrefectureListModelTests.self).url(forResource: "test_weather", withExtension: "gif")!
        image = weatherFactory.makeImage(url: url.absoluteString, title: "", height: 0, width: 0)
        forecast = weatherFactory.makeForecast(date: "", dateLabel: "", image: image,
                                               telop: "", temperature: nil)
        XCTAssertNotNil(model.getImageData(from: forecast))
    }
    
    private func makeWeather() -> Weather {
        let url = Bundle(for: PrefectureListModelTests.self).url(forResource: "TestWeather", withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return try! JSONDecoder().decode(Weather.self, from: data)
    }
    
    private func makeEmptyForecastsWeather() -> Weather? {
        return weatherFactory.makeWeather(link: "", title: "", copyright: nil,
                                          descriptionField: nil, publicTime: "", location: nil,
                                          forecast: nil, pinpointLocation: nil)
    }
    
    private func makeForecast() -> Forecast {
        return weatherFactory.makeForecast(date: "", dateLabel: "", image: nil, telop: "", temperature: nil)!
    }
}

