//
//	CityDataList.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct CityData : Codable {

	let area : Int
	let cityId : String
	let name : String


	enum CodingKeys: String, CodingKey {
		case area = "area"
		case cityId = "cityId"
		case name = "name"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		area = try values.decodeIfPresent(Int.self, forKey: .area) ?? 0
		cityId = try values.decodeIfPresent(String.self, forKey: .cityId) ?? ""
		name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
	}


}
