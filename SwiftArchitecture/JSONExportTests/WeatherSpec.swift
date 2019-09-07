//
//  WeatherSpec.swift
//  JSONExportTests
//
//  Created by am10 on 2019/09/07.
//  Copyright © 2019 am10. All rights reserved.
//

import Quick
import Nimble
@testable import JSONExport

class WeatherSpec: QuickSpec {
    override func spec() {
        describe("Max") {
            let text = """
 { "celsius": "26", "fahrenheit": "78.8" }
 """
            let max = try? JSONDecoder().decode(Max.self, from: text.data(using: .utf8)!)
            it ("decodable") {
                expect(max).notTo(beNil())
                expect(max?.celsius).to(equal("26"))
                expect(max?.fahrenheit).to(equal("78.8"))
            }
        }
        
        describe("Location") {
            let text = """
 {"city":"大阪","area":"近畿","prefecture":"大阪府"}
 """
            let location = try? JSONDecoder().decode(Location.self, from: text.data(using: .utf8)!)
            it ("decodable") {
                expect(location).notTo(beNil())
                expect(location?.city).to(equal("大阪"))
                expect(location?.area).to(equal("近畿"))
                expect(location?.prefecture).to(equal("大阪府"))
            }
        }
        
        describe("Description") {
            let text = """
 { "publicTime": "2019-09-07T16:32:00+0900", "text": "近畿地方は、高気圧に覆われておおむね晴れています。" }
 """
            let description = try? JSONDecoder().decode(Description.self, from: text.data(using: .utf8)!)
            it ("decodable") {
                expect(description).notTo(beNil())
                expect(description?.publicTime).to(equal("2019-09-07T16:32:00+0900"))
                expect(description?.text).to(equal("近畿地方は、高気圧に覆われておおむね晴れています。"))
            }
        }
        
        describe("Provider") {
            let text = """
 { "link": "http://tenki.jp/", "name": "日本気象協会" }
 """
            let provider = try? JSONDecoder().decode(Provider.self, from: text.data(using: .utf8)!)
            it ("decodable") {
                expect(provider).notTo(beNil())
                expect(provider?.link).to(equal("http://tenki.jp/"))
                expect(provider?.name).to(equal("日本気象協会"))
            }
        }
        
        describe("Image") {
            let text = """
 { "width":50, "url":"http://weather.livedoor.com/img/icon/2.gif",
            "title":"晴時々曇", "height":31}
 """
            let image = try? JSONDecoder().decode(Image.self, from: text.data(using: .utf8)!)
            it ("decodable") {
                expect(image).notTo(beNil())
                expect(image?.height).to(equal(31))
                expect(image?.width).to(equal(50))
                expect(image?.title).to(equal("晴時々曇"))
                expect(image?.url).to(equal("http://weather.livedoor.com/img/icon/2.gif"))
            }
        }
        
        describe("Temperature") {
            context("null") {
                let text = """
 { "min" : null, "max" : null }
 """
                let temperature = try? JSONDecoder().decode(Temperature.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(temperature).notTo(beNil())
                    expect(temperature?.min).to(beNil())
                    expect(temperature?.max).to(beNil())
                }
            }
            
            context("exist data") {
                let text = """
 { "min" : {"celsius" : "3", "fahrenheit" : "37.4"},
   "max" : {"celsius" : "13", "fahrenheit" : "55.4"} }
 """
                let temperature = try? JSONDecoder().decode(Temperature.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(temperature).notTo(beNil())
                    expect(temperature?.min).notTo(beNil())
                    expect(temperature?.min?.celsius).to(equal("3"))
                    expect(temperature?.min?.fahrenheit).to(equal("37.4"))
                    expect(temperature?.max).notTo(beNil())
                    expect(temperature?.max?.celsius).to(equal("13"))
                    expect(temperature?.max?.fahrenheit).to(equal("55.4"))
                }
            }
        }
        
        describe("Copyright") {
            context("null") {
                let text = """
 { "provider" : null,
 "link" : "http://weather.livedoor.com/", "title" : "(C) LINE Corporation",
 "image" : null
 }
 """
                let copyright = try? JSONDecoder().decode(Copyright.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(copyright).notTo(beNil())
                    expect(copyright?.provider).to(beNil())
                    expect(copyright?.link).to(equal("http://weather.livedoor.com/"))
                    expect(copyright?.title).to(equal("(C) LINE Corporation"))
                    expect(copyright?.image).to(beNil())
                }
            }
            
            context("empty") {
                let text = """
 { "provider" : [],
 "link" : "http://weather.livedoor.com/", "title" : "(C) LINE Corporation",
 "image" : {}
 }
 """
                let copyright = try? JSONDecoder().decode(Copyright.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(copyright).notTo(beNil())
                    expect(copyright?.provider).notTo(beNil())
                    expect(copyright?.link).to(equal("http://weather.livedoor.com/"))
                    expect(copyright?.title).to(equal("(C) LINE Corporation"))
                    expect(copyright?.image).notTo(beNil())
                }
            }
            
            context("exist data") {
                let text = """
 { "provider" : [{"link" : "http://tenki.jp/", "name" : "日本気象協会"}],
 "link" : "http://weather.livedoor.com/", "title" : "(C) LINE Corporation",
 "image" : { "width" : 118, "height" : 26, "title" : "livedoor 天気情報",
            "url" : "http://weather.livedoor.com/img/cmn/livedoor.gif"}
 }
 """
                let copyright = try? JSONDecoder().decode(Copyright.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(copyright).notTo(beNil())
                    expect(copyright?.provider).notTo(beNil())
                    expect(copyright?.provider).to(haveCount(1))
                    let providerData = copyright?.provider?.first
                    expect(providerData).notTo(beNil())
                    expect(providerData?.link).to(equal("http://tenki.jp/"))
                    expect(providerData?.name).to(equal("日本気象協会"))
                    expect(copyright?.link).to(equal("http://weather.livedoor.com/"))
                    expect(copyright?.title).to(equal("(C) LINE Corporation"))
                    expect(copyright?.image).notTo(beNil())
                    expect(copyright?.image?.height).to(equal(26))
                    expect(copyright?.image?.width).to(equal(118))
                    expect(copyright?.image?.title).to(equal("livedoor 天気情報"))
                    expect(copyright?.image?.url).to(equal("http://weather.livedoor.com/img/cmn/livedoor.gif"))
                }
            }
        }
        
        describe("Forecast") {
            context("null") {
                let text = """
 {
    "dateLabel" : "今日",
    "telop" : "晴のち曇",
    "date" : "2013-01-29",
    "temperature" : null,
    "image" : null
 }
 """
                let forecast = try? JSONDecoder().decode(Forecast.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(forecast).notTo(beNil())
                    expect(forecast?.temperature).to(beNil())
                    expect(forecast?.image).to(beNil())
                    expect(forecast?.date).to(equal("2013-01-29"))
                    expect(forecast?.telop).to(equal("晴のち曇"))
                    expect(forecast?.dateLabel).to(equal("今日"))
                }
            }
            
            context("empty") {
                let text = """
 {
    "dateLabel" : "今日",
    "telop" : "晴のち曇",
    "date" : "2013-01-29",
    "temperature" : {},
    "image" : {}
 }
 """
                let forecast = try? JSONDecoder().decode(Forecast.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(forecast).notTo(beNil())
                    expect(forecast?.temperature).notTo(beNil())
                    expect(forecast?.image).notTo(beNil())
                    expect(forecast?.date).to(equal("2013-01-29"))
                    expect(forecast?.telop).to(equal("晴のち曇"))
                    expect(forecast?.dateLabel).to(equal("今日"))
                }
            }
            
            context("exist data") {
                let text = """
 {
    "dateLabel" : "今日",
    "telop" : "晴のち曇",
    "date" : "2013-01-29",
    "temperature" : {
        "min" : null,
        "max" : {
            "celsius" : "11",
            "fahrenheit" : "51.8"
        }
    },
    "image" : {
        "width" : 50,
        "url" : "http://weather.livedoor.com/img/icon/5.gif",
        "title" : "晴のち曇",
        "height" : 31
    }
 }
 """
                let forecast = try? JSONDecoder().decode(Forecast.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(forecast).notTo(beNil())
                    expect(forecast?.temperature).notTo(beNil())
                    expect(forecast?.temperature?.min).to(beNil())
                    expect(forecast?.temperature?.max).notTo(beNil())
                    expect(forecast?.temperature?.max?.celsius).to(equal("11"))
                    expect(forecast?.temperature?.max?.fahrenheit).to(equal("51.8"))
                    expect(forecast?.image).notTo(beNil())
                    expect(forecast?.image?.width).to(equal(50))
                    expect(forecast?.image?.height).to(equal(31))
                    expect(forecast?.image?.url).to(equal("http://weather.livedoor.com/img/icon/5.gif"))
                    expect(forecast?.image?.title).to(equal("晴のち曇"))
                    expect(forecast?.date).to(equal("2013-01-29"))
                    expect(forecast?.telop).to(equal("晴のち曇"))
                    expect(forecast?.dateLabel).to(equal("今日"))
                }
            }
        }
        
        describe("Weather") {
            context("null") {
                let text = """
 {
   "publicTime" : "2013-01-29T11:00:00+0900",
   "title" : "福岡県 久留米 の天気",
   "description" : null,
   "link" : "http://weather.livedoor.com/area/forecast/400040",
   "forecasts" : null,
   "location" : null,
  "pinpointLocations" : null,
   "copyright" : null
 }
 """
                let weather = try? JSONDecoder().decode(Weather.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(weather).notTo(beNil())
                    expect(weather?.forecasts).to(beNil())
                    expect(weather?.copyright).to(beNil())
                    expect(weather?.location).to(beNil())
                    expect(weather?.descriptionField).to(beNil())
                    expect(weather?.pinpointLocations).to(beNil())
                    expect(weather?.link).to(equal("http://weather.livedoor.com/area/forecast/400040"))
                    expect(weather?.publicTime).to(equal("2013-01-29T11:00:00+0900"))
                    expect(weather?.title).to(equal("福岡県 久留米 の天気"))
                }
            }
            
            context("empty") {
                let text = """
 {
   "publicTime" : "2013-01-29T11:00:00+0900",
   "title" : "福岡県 久留米 の天気",
   "description" : {},
   "link" : "http://weather.livedoor.com/area/forecast/400040",
   "forecasts" : [],
   "location" : {},
  "pinpointLocations" : [],
   "copyright" : {}
 }
 """
                let weather = try? JSONDecoder().decode(Weather.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(weather).notTo(beNil())
                    expect(weather?.forecasts).notTo(beNil())
                    expect(weather?.copyright).notTo(beNil())
                    expect(weather?.location).notTo(beNil())
                    expect(weather?.descriptionField).notTo(beNil())
                    expect(weather?.pinpointLocations).notTo(beNil())
                    expect(weather?.link).to(equal("http://weather.livedoor.com/area/forecast/400040"))
                    expect(weather?.publicTime).to(equal("2013-01-29T11:00:00+0900"))
                    expect(weather?.title).to(equal("福岡県 久留米 の天気"))
                }
            }
            
            context("exist data") {
                let text = """
 {
   "publicTime" : "2013-01-29T11:00:00+0900",
   "title" : "福岡県 久留米 の天気",
   "description" : {
      "text" : "九州北部地方は、高気圧に覆われて晴れています。",
      "publicTime" : "2013-01-29T10:37:00+0900"
   },
   "link" : "http://weather.livedoor.com/area/forecast/400040",
   "forecasts" : [
      {
         "dateLabel" : "今日",
         "telop" : "晴のち曇",
         "date" : "2013-01-29",
         "temperature" : {
            "min" : null,
            "max" : {
               "celsius" : "11",
               "fahrenheit" : "51.8"
            }
         },
         "image" : {
            "width" : 50,
            "url" : "http://weather.livedoor.com/img/icon/5.gif",
            "title" : "晴のち曇",
            "height" : 31
         }
      }
   ],
   "location" : {
      "city" : "久留米",
      "area" : "九州",
      "prefecture" : "福岡県"
   },
  "pinpointLocations" : [
      {
         "link" : "http://weather.livedoor.com/area/forecast/4020200",
         "name" : "大牟田市"
      }
   ],
   "copyright" : {
      "provider" : [
         {
            "link" : "http://tenki.jp/",
            "name" : "日本気象協会"
         }
      ],
      "link" : "http://weather.livedoor.com/",
      "title" : "(C) LINE Corporation",
      "image" : {
         "width" : 118,
         "link" : "http://weather.livedoor.com/",
         "url" : "http://weather.livedoor.com/img/cmn/livedoor.gif",
         "title" : "livedoor 天気情報",
         "height" : 26
      }
   }
 }
 """
                let weather = try? JSONDecoder().decode(Weather.self, from: text.data(using: .utf8)!)
                it ("decodable") {
                    expect(weather).notTo(beNil())
                    expect(weather?.forecasts).notTo(beNil())
                    expect(weather?.forecasts).to(haveCount(1))
                    let forecast = weather?.forecasts?.first
                    expect(forecast?.temperature).notTo(beNil())
                    expect(forecast?.temperature?.min).to(beNil())
                    expect(forecast?.temperature?.max).notTo(beNil())
                    expect(forecast?.temperature?.max?.celsius).to(equal("11"))
                    expect(forecast?.temperature?.max?.fahrenheit).to(equal("51.8"))
                    expect(forecast?.image).notTo(beNil())
                    expect(forecast?.image?.width).to(equal(50))
                    expect(forecast?.image?.height).to(equal(31))
                    expect(forecast?.image?.url).to(equal("http://weather.livedoor.com/img/icon/5.gif"))
                    expect(forecast?.image?.title).to(equal("晴のち曇"))
                    expect(forecast?.date).to(equal("2013-01-29"))
                    expect(forecast?.telop).to(equal("晴のち曇"))
                    expect(forecast?.dateLabel).to(equal("今日"))
                    
                    let copyright = weather?.copyright
                    expect(copyright).notTo(beNil())
                    expect(copyright?.provider).notTo(beNil())
                    expect(copyright?.provider).to(haveCount(1))
                    let providerData = copyright?.provider?.first
                    expect(providerData).notTo(beNil())
                    expect(providerData?.link).to(equal("http://tenki.jp/"))
                    expect(providerData?.name).to(equal("日本気象協会"))
                    expect(copyright?.link).to(equal("http://weather.livedoor.com/"))
                    expect(copyright?.title).to(equal("(C) LINE Corporation"))
                    expect(copyright?.image).notTo(beNil())
                    expect(copyright?.image?.height).to(equal(26))
                    expect(copyright?.image?.width).to(equal(118))
                    expect(copyright?.image?.title).to(equal("livedoor 天気情報"))
                    expect(copyright?.image?.url).to(equal("http://weather.livedoor.com/img/cmn/livedoor.gif"))
                    
                    let location = weather?.location
                    expect(location).notTo(beNil())
                    expect(location?.city).to(equal("久留米"))
                    expect(location?.area).to(equal("九州"))
                    expect(location?.prefecture).to(equal("福岡県"))
                    
                    let description = weather?.descriptionField
                    expect(description).notTo(beNil())
                    expect(description?.publicTime).to(equal("2013-01-29T10:37:00+0900"))
                    expect(description?.text).to(equal("九州北部地方は、高気圧に覆われて晴れています。"))
                    expect(weather?.pinpointLocations).notTo(beNil())
                    expect(weather?.pinpointLocations).to(haveCount(1))
                    let provider = weather?.pinpointLocations?.first
                    expect(provider).notTo(beNil())
                    expect(provider?.link).to(equal("http://weather.livedoor.com/area/forecast/4020200"))
                    expect(provider?.name).to(equal("大牟田市"))
                    
                    expect(weather?.link).to(equal("http://weather.livedoor.com/area/forecast/400040"))
                    expect(weather?.publicTime).to(equal("2013-01-29T11:00:00+0900"))
                    expect(weather?.title).to(equal("福岡県 久留米 の天気"))
                }
            }
        }
    }
}
