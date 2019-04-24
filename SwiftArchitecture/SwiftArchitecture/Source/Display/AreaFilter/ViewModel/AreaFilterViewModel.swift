//
//  AreaFilterViewModel.swift
//  SwiftArchitecture
//
//  Created by makoto on 2019/04/24.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation

class AreaFilterViewModel {
    let tableDataList: [Area] = [.hokkaido, .tohoku, .kanto, .chubu, .kinki, .chugoku, .shikoku, .kyushu]
    var selectedAreaTypes: [Area]!
    
    
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
