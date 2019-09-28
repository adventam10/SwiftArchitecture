//
//  AreaFilterModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

final class AreaFilterModel {
    
    let tableDataList: [Area] = [.hokkaido, .tohoku, .kanto, .chubu, .kinki, .chugoku, .shikoku, .kyushu]
    var selectedAreaTypes: [Area]!
    
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
    
    func isAllCheck() -> Bool {
        if selectedAreaTypes.isEmpty {
            return false
        }
        for areaType in tableDataList {
            if !selectedAreaTypes.contains(areaType) {
                return false
            }
        }
        return true
    }
    
    func setupSelectedAreaTypes(areaType: Area) {
        if let index = selectedAreaTypes.firstIndex(of: areaType) {
            selectedAreaTypes.remove(at: index)
        } else {
            selectedAreaTypes.append(areaType)
        }
    }
    
    func setupSelectedAreaTypes(isAllCheck: Bool) {
        selectedAreaTypes.removeAll()
        if isAllCheck {
            selectedAreaTypes.append(contentsOf: tableDataList)
        }
    }
}
