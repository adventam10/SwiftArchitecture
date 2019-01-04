//
//	Forecast.swift
//
//	Create by am10 on 3/1/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Forecast : Codable {

	let date : String
	let dateLabel : String
	let image : Image?
	let telop : String
	let temperature : Temperature?


	enum CodingKeys: String, CodingKey {
		case date = "date"
		case dateLabel = "dateLabel"
		case image
		case telop = "telop"
		case temperature
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		date = try values.decodeIfPresent(String.self, forKey: .date) ?? ""
		dateLabel = try values.decodeIfPresent(String.self, forKey: .dateLabel) ?? ""
        image = try values.decodeIfPresent(Image.self, forKey: .image)
		telop = try values.decodeIfPresent(String.self, forKey: .telop) ?? ""
		temperature = try values.decodeIfPresent(Temperature.self, forKey: .temperature)
	}


}
