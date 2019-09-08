//
//  CityId.swift
//  SwiftArchitectureTests
//
//  Created by makoto on 2019/09/08.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation

enum CityId: String {
    case hokkaido = "016010"
    case aomori = "020010"
    case iwate = "030010"
    case akita = "050010"
    case miyagi = "040010"
    case yamagata = "060010"
    case fukushima = "070010"
    case ibaraki = "080010"
    case chiba = "120010"
    case tochigi = "090010"
    case gunma = "100010"
    case saitama = "110010"
    case tokyo = "130010"
    case kanagawa = "140010"
    case niigata = "150010"
    case nagano = "200010"
    case yamanashi = "190010"
    case shizuoka = "220010"
    case aichi = "230010"
    case mie = "240010"
    case gifu = "210010"
    case fukui = "180010"
    case ishikawa = "170010"
    case toyama = "160010"
    case shiga = "250010"
    case kyoto = "260010"
    case hyogo = "280010"
    case nara = "290010"
    case wakayama = "300010"
    case osaka = "270000"
    case tottori = "310010"
    case okayama = "330010"
    case hiroshima = "340010"
    case yamaguchi = "350020"
    case shimane = "320010"
    case kagawa = "370000"
    case tokushima = "360010"
    case kochi = "390010"
    case ehime = "380010"
    case fukuoka = "400010"
    case oita = "440010"
    case miyazaki = "450010"
    case kagoshima = "460010"
    case kumamoto = "430010"
    case saga = "410010"
    case nagasaki = "420010"
    case okinawa = "471010"
    static func cityIds(_ cityIds: [CityId]) -> [String] {
        return cityIds.map { $0.rawValue }
    }
}
