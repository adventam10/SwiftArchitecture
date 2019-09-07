//
//  AreaFilterViewModel.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/04/24.
//  Copyright © 2019 am10. All rights reserved.
//

import Foundation
import DIKit
import ReactiveSwift

struct AreaFilterViewModel: Injectable {
    struct Dependency {
        let selectedAreaTypes: [Area]
    }
    
    init(dependency: Dependency) {
        let selectedAreaTypes = dependency.selectedAreaTypes.isEmpty ? Area.allCases : dependency.selectedAreaTypes
        self.selectedAreaTypes = MutableProperty(selectedAreaTypes)
    }
    
    let tableDataList = Area.allCases
    var selectedAreaTypes: MutableProperty<[Area]>!
    
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
