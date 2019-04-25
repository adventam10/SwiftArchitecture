//
//  AreaFilterViewModel.swift
//  SwiftArchitecture
//
//  Created by makoto on 2019/04/24.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation
import ReactiveSwift

class AreaFilterViewModel {
    let tableDataList: [Area] = [.hokkaido, .tohoku, .kanto, .chubu, .kinki, .chugoku, .shikoku, .kyushu]
    var selectedAreaTypes: MutableProperty<[Area]>!
    init(selectedAreaTypes: [Area]) {
        self.selectedAreaTypes =  MutableProperty(selectedAreaTypes)
    }
    func isAllCheck() -> Bool {
        if selectedAreaTypes.value.isEmpty {
            return false
        }
        for areaType in tableDataList {
            if !selectedAreaTypes.value.contains(areaType) {
                return false
            }
        }
        return true
    }
    
    func setupSelectedAreaTypes(areaType: Area) {
        if let index = selectedAreaTypes.value.firstIndex(of: areaType) {
            selectedAreaTypes.value.remove(at: index)
        } else {
            selectedAreaTypes.value.append(areaType)
        }
    }
    
    func setupSelectedAreaTypes(isAllCheck: Bool) {
        var selectedTypes = [Area]()
        if isAllCheck {
            selectedTypes.append(contentsOf: tableDataList)
        }
        selectedAreaTypes.value = selectedTypes
    }
    
    func createCellModel(index: Int) -> AreaFilterCellViewModel {
        let title = tableDataList[index].getName()
        let isCheck = selectedAreaTypes.value.contains(tableDataList[index])
        return AreaFilterCellViewModel(title: title, isCheck: isCheck)
    }
}
