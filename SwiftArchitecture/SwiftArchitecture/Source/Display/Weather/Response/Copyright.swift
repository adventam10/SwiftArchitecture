//
//	Copyright.swift
//
//	Create by am10 on 3/1/2019
//	Copyright © 2019. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Copyright : Codable {

	let image : Image?
	let link : String
	let provider : [Provider]?
	let title : String


	enum CodingKeys: String, CodingKey {
		case image
		case link = "link"
		case provider = "provider"
		case title = "title"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		image = try values.decodeIfPresent(Image.self, forKey: .image)
		link = try values.decodeIfPresent(String.self, forKey: .link) ?? ""
		provider = try values.decodeIfPresent([Provider].self, forKey: .provider)
		title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
	}


}
