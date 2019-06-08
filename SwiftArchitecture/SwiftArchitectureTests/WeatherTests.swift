//
//  WeatherTests.swift
//  SwiftArchitectureTests
//
//  Created by makoto on 2019/04/29.
//  Copyright © 2019 am10. All rights reserved.
//

import XCTest
@testable import SwiftArchitecture

class WeatherTests: XCTestCase {

    let resolver = AppResolverImpl()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherParse() {
        var weather = createWeather()
        XCTAssertNotNil(weather)
        
        weather = try? JSONDecoder().decode(Weather.self, from: "{}".data(using: .utf8)!)
        XCTAssertNotNil(weather)
    }

    func testForecastParse() {
        let viewModel = createViewModel()
        
        var forecast = createForecast(text: createJsonText_ForeCast())
        var model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertNotEqual(model.subDateLabel, "")
        XCTAssertNotEqual(model.telop, "")
        XCTAssertNotEqual(model.maxCelsius, "-")
        XCTAssertNotEqual(model.minCelsius, "-")
        XCTAssertNotNil(model.imagUrl)
        
        forecast = createForecast(text: createForeCast_text_null())
        model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertEqual(model.subDateLabel, "")
        XCTAssertEqual(model.telop, "")
        XCTAssertEqual(model.maxCelsius, "-")
        XCTAssertEqual(model.minCelsius, "-")
        XCTAssertNil(model.imagUrl)
        
        forecast = createForecast(text: createForeCast_text_blank())
        model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertEqual(model.subDateLabel, "")
        XCTAssertEqual(model.telop, "")
        XCTAssertEqual(model.maxCelsius, "-")
        XCTAssertEqual(model.minCelsius, "-")
        XCTAssertNil(model.imagUrl)
        
        forecast = createForecast(text: createForeCast_temperature_null())
        model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertEqual(model.maxCelsius, "-")
        XCTAssertEqual(model.minCelsius, "-")
        
        forecast = createForecast(text: createForeCast_temperature_blank())
        model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertEqual(model.maxCelsius, "-")
        XCTAssertEqual(model.minCelsius, "-")
        
        forecast = createForecast(text: createForeCast_max_blank())
        model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertEqual(model.maxCelsius, "-")
        
        forecast = createForecast(text: createForeCast_max_null())
        model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertEqual(model.maxCelsius, "-")
        
        forecast = createForecast(text: createForeCast_min_blank())
        model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertEqual(model.minCelsius, "-")
        
        forecast = createForecast(text: createForeCast_min_null())
        model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertEqual(model.minCelsius, "-")
        
        forecast = createForecast(text: createForeCast_image_null())
        model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertNil(model.imagUrl)
        
        forecast = createForecast(text: createForeCast_image_blank())
        model = viewModel.createWeatherInfoViewModel(date: .today, forecast: forecast)
        XCTAssertNil(model.imagUrl)
    }
    
    func createViewModel() -> WeatherViewModel {
        let weather = createWeather()!
        let text = """
{
                     "cityId": "270000",
                     "name": "大阪",
                     "area": 4
                     }
"""
        let cityData = try! JSONDecoder().decode(CityData.self, from: text.data(using: .utf8)!)
        let viewModel = resolver.resolveWeatherViewModel(weather: weather, cityData: cityData)
        return viewModel
    }
    func createWeather() -> Weather? {
        guard let filePath = R.file.testWeatherJson.path(),
            let data = FileManager.default.contents(atPath: filePath),
            let weather = try? JSONDecoder().decode(Weather.self, from: data) else {
                return nil
        }
        return weather
    }
    
    func createForecast(text: String) -> Forecast {
        return try! JSONDecoder().decode(Forecast.self, from: text.data(using: .utf8)!)
    }
    
    func createJsonText_ForeCast() -> String {
        return """
        {
        "dateLabel": "今日",
        "telop": "曇のち雨",
        "date": "2019-04-29",
        "temperature": {
        "min": {
        "celsius": "12",
        "fahrenheit": "53.6"
        },
        "max": {
        "celsius": "20",
        "fahrenheit": "68.0"
        }
        },
        "image": {
        "width": 50,
        "url": "http://weather.livedoor.com/img/icon/13.gif",
        "title": "曇のち雨",
        "height": 31
        }
        }
        """
    }
    
    func createForeCast_temperature_null() -> String {
        return """
        {
        "dateLabel": "今日",
        "telop": "曇のち雨",
        "date": "2019-04-29",
        "temperature": null,
        "image": {
        "width": 50,
        "url": "http://weather.livedoor.com/img/icon/13.gif",
        "title": "曇のち雨",
        "height": 31
        }
        }
        """
    }
    
    func createForeCast_temperature_blank() -> String {
        return """
        {
        "dateLabel": "今日",
        "telop": "曇のち雨",
        "date": "2019-04-29",
        "temperature": {
        },
        "image": {
        "width": 50,
        "url": "http://weather.livedoor.com/img/icon/13.gif",
        "title": "曇のち雨",
        "height": 31
        }
        }
        """
    }
    
    func createForeCast_max_null() -> String {
        return """
        {
        "dateLabel": "今日",
        "telop": "曇のち雨",
        "date": "2019-04-29",
        "temperature": {
        "min": {
        "celsius": "12",
        "fahrenheit": "53.6"
        },
        "max": null
        },
        "image": {
        "width": 50,
        "url": "http://weather.livedoor.com/img/icon/13.gif",
        "title": "曇のち雨",
        "height": 31
        }
        }
        """
    }
    
    func createForeCast_max_blank() -> String {
        return """
        {
        "dateLabel": "今日",
        "telop": "曇のち雨",
        "date": "2019-04-29",
        "temperature": {
        "min": {
        "celsius": "12",
        "fahrenheit": "53.6"
        },
        "max": {
        }
        },
        "image": {
        "width": 50,
        "url": "http://weather.livedoor.com/img/icon/13.gif",
        "title": "曇のち雨",
        "height": 31
        }
        }
        """
    }
    
    func createForeCast_min_null() -> String {
        return """
        {
        "dateLabel": "今日",
        "telop": "曇のち雨",
        "date": "2019-04-29",
        "temperature": {
        "min": null,
        "max": {
        "celsius": "20",
        "fahrenheit": "68.0"
        }
        },
        "image": {
        "width": 50,
        "url": "http://weather.livedoor.com/img/icon/13.gif",
        "title": "曇のち雨",
        "height": 31
        }
        }
        """
    }
    
    func createForeCast_min_blank() -> String {
        return """
        {
        "dateLabel": "今日",
        "telop": "曇のち雨",
        "date": "2019-04-29",
        "temperature": {
        "min": {
        },
        "max": {
        "celsius": "20",
        "fahrenheit": "68.0"
        }
        },
        "image": {
        "width": 50,
        "url": "http://weather.livedoor.com/img/icon/13.gif",
        "title": "曇のち雨",
        "height": 31
        }
        }
        """
    }

    func createForeCast_text_blank() -> String {
        return """
        {
        "dateLabel": "",
        "telop": "",
        "date": "",
        "temperature": {
        "min": {
        "celsius": "",
        "fahrenheit": ""
        },
        "max": {
        "celsius": "",
        "fahrenheit": ""
        }
        },
        "image": {
        "width": 50,
        "url": "",
        "title": "",
        "height": 31
        }
        }
        """
    }
    
    func createForeCast_text_null() -> String {
        return """
        {
        "dateLabel": null,
        "telop": null,
        "date": null,
        "temperature": {
        "min": {
        "celsius": null,
        "fahrenheit": null
        },
        "max": {
        "celsius": null,
        "fahrenheit": null
        }
        },
        "image": {
        "width": 50,
        "url": null,
        "title": null,
        "height": 31
        }
        }
        """
    }
    
    func createForeCast_image_blank() -> String {
        return """
        {
        "dateLabel": "今日",
        "telop": "曇のち雨",
        "date": "2019-04-29",
        "temperature": {
        "min": {
        "celsius": "12",
        "fahrenheit": "53.6"
        },
        "max": {
        "celsius": "20",
        "fahrenheit": "68.0"
        }
        },
        "image": {
        }
        }
        """
    }
    
    func createForeCast_image_null() -> String {
        return """
        {
        "dateLabel": "今日",
        "telop": "曇のち雨",
        "date": "2019-04-29",
        "temperature": {
        "min": {
        "celsius": "12",
        "fahrenheit": "53.6"
        },
        "max": {
        "celsius": "20",
        "fahrenheit": "68.0"
        }
        },
        "image": null
        }
        """
    }
}
