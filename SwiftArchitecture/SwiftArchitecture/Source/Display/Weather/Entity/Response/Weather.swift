//
//	Weather.swift
//
//	Create by am10 on 3/1/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Weather : Codable {

	let copyright : Copyright?
	let descriptionField : Description?
	let forecasts : [Forecast]?
	let link : String
	let location : Location?
	let pinpointLocations : [Provider]?
	let publicTime : String
	let title : String


	enum CodingKeys: String, CodingKey {
		case copyright
		case descriptionField
		case forecasts = "forecasts"
		case link = "link"
		case location
		case pinpointLocations = "pinpointLocations"
		case publicTime = "publicTime"
		case title = "title"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		copyright = try values.decodeIfPresent(Copyright.self, forKey: .copyright)
		descriptionField = try values.decodeIfPresent(Description.self, forKey: .descriptionField)
		forecasts = try values.decodeIfPresent([Forecast].self, forKey: .forecasts)
		link = try values.decodeIfPresent(String.self, forKey: .link) ?? ""
		location = try values.decodeIfPresent(Location.self, forKey: .location)
		pinpointLocations = try values.decodeIfPresent([Provider].self, forKey: .pinpointLocations)
		publicTime = try values.decodeIfPresent(String.self, forKey: .publicTime) ?? ""
		title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
	}


}
