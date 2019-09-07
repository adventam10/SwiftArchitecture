//
//  WeatherFactory.swift
//  SwiftArchitectureTests
//
//  Created by am10 on 2019/09/07.
//  Copyright © 2019 am10. All rights reserved.
//

import JSONExport

func makeMax(celsius: String, fahrenheit: String) -> Max? {
    let text = """
    { "celsius": "\(celsius)", "fahrenheit": "\(fahrenheit)" }
    """
    return try? JSONDecoder().decode(Max.self, from: text.data(using: .utf8)!)
}

func makeForecast(date: String, dateLabel: String, image: Image?,
                  telop: String, temperature: Temperature?) -> Forecast? {
    let text = """
    {
        "dateLabel": "\(dateLabel)",
        "telop": "\(telop)",
        "date": "\(date)",
        "temperature": \(encodeJSON(temperature)),
        "image": \(encodeJSON(image))
        }
    """
    return try? JSONDecoder().decode(Forecast.self, from: text.data(using: .utf8)!)
}

func makeLocation(area: String, city: String, prefecture: String) -> Location? {
    let text = """
    {
    "area": "\(area)",
    "city": "\(city)",
    "prefecture": "\(prefecture)"
    }
    """
    return try? JSONDecoder().decode(Location.self, from: text.data(using: .utf8)!)
}

func makeLocation(text: String, publicTime: String) -> Description? {
    let text = """
    {
    "text": "\(text)",
    "publicTime": "\(publicTime)"
    }
    """
    return try? JSONDecoder().decode(Description.self, from: text.data(using: .utf8)!)
}

func makeCopyright(link: String, title: String, image: Image?, provider: Provider?) -> Copyright? {
    let providers = (provider != nil) ? encodeJSON(provider) : ""
    let text = """
    {
    "link": "\(link)",
    "title": "\(title)",
    "image": \(encodeJSON(image)),
    "provider": [\(providers)]
    }
    """
    return try? JSONDecoder().decode(Copyright.self, from: text.data(using: .utf8)!)
}

func makeProvider(link: String, name: String) -> Provider? {
    let text = """
    {
    "link": "\(link)",
    "name": "\(name)"
    }
    """
    return try? JSONDecoder().decode(Provider.self, from: text.data(using: .utf8)!)
}

func makeImage(url: String, title: String, height: Int, width: Int) -> Image? {
    let text = """
    {
    "url": "\(url)",
    "title": "\(title)",
    "height": \(height),
    "width": \(width)
    }
    """
    return try? JSONDecoder().decode(Image.self, from: text.data(using: .utf8)!)
}

func makeTemperature(max: Max?, min: Max?) -> Temperature? {
    let text = """
    {
    "max": \(encodeJSON(max)),
    "min": \(encodeJSON(min))
    }
    """
    return try? JSONDecoder().decode(Temperature.self, from: text.data(using: .utf8)!)
}

func makeWeather(link: String, title: String, copyright: Copyright?,
                 descriptionField: Description?, publicTime: String,
                 location: Location?, forecast: Forecast?,
                 pinpointLocation: Provider?) -> Weather? {
    let pinpointLocations = (pinpointLocation != nil) ? encodeJSON(pinpointLocation) : ""
    let forecasts = (forecast != nil) ? encodeJSON(forecast) : ""
    let text = """
    {
    "link": "\(link)",
    "title": "\(title)",
    "publicTime": "\(publicTime)",
    "copyright": \(encodeJSON(copyright)),
    "description": \(encodeJSON(descriptionField)),
    "location": \(encodeJSON(location)),
    "pinpointLocations": [\(pinpointLocations)],
    "forecasts": [\(forecasts)]
    }
    """
    return try? JSONDecoder().decode(Weather.self, from: text.data(using: .utf8)!)
}

private func encodeJSON<T>(_ json: T?) -> String where T: Codable {
    guard let data = try? JSONEncoder().encode(json),
        let jsonText = String(data: data, encoding: .utf8) else {
        return "null"
    }
    return jsonText
}
