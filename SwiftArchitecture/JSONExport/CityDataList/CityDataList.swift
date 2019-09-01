//
//	.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

public struct CityDataList : Codable {

	public let cityDataList : [CityData]?


	enum CodingKeys: String, CodingKey {
		case cityDataList = "cityDataList"
	}
    public init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		cityDataList = try values.decodeIfPresent([CityData].self, forKey: .cityDataList)
	}


}
