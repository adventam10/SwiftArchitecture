//
//	Max.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Max : Codable {

	let celsius : String
	let fahrenheit : String


	enum CodingKeys: String, CodingKey {
		case celsius = "celsius"
		case fahrenheit = "fahrenheit"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		celsius = try values.decodeIfPresent(String.self, forKey: .celsius) ?? ""
		fahrenheit = try values.decodeIfPresent(String.self, forKey: .fahrenheit) ?? ""
	}


}
