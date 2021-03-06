//
//	Image.swift
//
//	Create by am10 on 3/1/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Image : Codable {

	let height : Int
	let link : String
	let title : String
	let url : String
	let width : Int


	enum CodingKeys: String, CodingKey {
		case height = "height"
		case link = "link"
		case title = "title"
		case url = "url"
		case width = "width"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		height = try values.decodeIfPresent(Int.self, forKey: .height) ?? 0
		link = try values.decodeIfPresent(String.self, forKey: .link) ?? ""
		title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
		url = try values.decodeIfPresent(String.self, forKey: .url) ?? ""
		width = try values.decodeIfPresent(Int.self, forKey: .width) ?? 0
	}


}
