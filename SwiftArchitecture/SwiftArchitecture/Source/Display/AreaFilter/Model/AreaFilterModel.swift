//
//  AreaFilterModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

protocol AreaFilterModelDelegate: AnyObject {
    
    func areaFilterModel(_ areaFilterModel: AreaFilterModel,
                        didChangeSelectedAreaTypes selectedAreaTypes: [AreaFilterModel.Area])
}

final class AreaFilterModel {
    
    enum Area: Int, CaseIterable {
        
        case hokkaido = 0
        case tohoku = 1
        case kanto = 2
        case chubu = 3
        case kinki = 4
        case chugoku = 5
        case shikoku = 6
        case kyushu = 7
        
        var name: String {
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
    
    weak var delegate: AreaFilterModelDelegate?
    let tableDataList = Area.allCases
    
    var selectedAreaTypes: [Area]! {
        didSet {
            delegate?.areaFilterModel(self, didChangeSelectedAreaTypes: selectedAreaTypes)
        }
    }
    
    var isAllCheck: Bool {
        if selectedAreaTypes.isEmpty {
            return false
        }
        return tableDataList.allSatisfy { selectedAreaTypes.contains($0) }
    }
    
    func selectAll() {
        selectedAreaTypes = tableDataList
    }
    
    func deselectAll() {
        selectedAreaTypes.removeAll()
    }
}
