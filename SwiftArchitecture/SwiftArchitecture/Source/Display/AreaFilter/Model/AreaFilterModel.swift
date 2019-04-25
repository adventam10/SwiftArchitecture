//
//  AreaFilterModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

enum Area: Int {
    case hokkaido = 0
    case tohoku = 1
    case kanto = 2
    case chubu = 3
    case kinki = 4
    case chugoku = 5
    case shikoku = 6
    case kyushu = 7
    func getName() -> String {
        switch self {
        case .hokkaido:
            return "北海道"
        case .tohoku:
            return "東北"
        case .kanto:
            return "関東"
        case .chubu:
            return "中部"
        case .kinki:
            return "近畿"
        case .chugoku:
            return "中国"
        case .shikoku:
            return "四国"
        case .kyushu:
            return "九州"
        }
    }
}