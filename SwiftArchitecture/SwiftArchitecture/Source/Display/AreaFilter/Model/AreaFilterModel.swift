//
//  AreaFilterModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

enum Area: Int, CaseIterable {
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
            return NSLocalizedString("area_hokkaido", comment: "")
        case .tohoku:
            return NSLocalizedString("area_tohoku", comment: "")
        case .kanto:
            return NSLocalizedString("area_kanto", comment: "")
        case .chubu:
            return NSLocalizedString("area_chubu", comment: "")
        case .kinki:
            return NSLocalizedString("area_kinki", comment: "")
        case .chugoku:
            return NSLocalizedString("area_chugoku", comment: "")
        case .shikoku:
            return NSLocalizedString("area_shikoku", comment: "")
        case .kyushu:
            return NSLocalizedString("area_kyushu", comment: "")
        }
    }
}
