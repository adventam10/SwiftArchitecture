//
//  AreaFilterPresenter.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/05.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

class AreaFilterPresenter {
    private weak var view: AreaFilterView?
    private let interactor: AreaFilterUsecase
    private let router: AreaFilterWireframe
    
    let tableDataList: [Area] = [.hokkaido, .tohoku, .kanto, .chubu, .kinki, .chugoku, .shikoku, .kyushu]
    var selectedAreaTypes: [Area]!
    var isAllCheck: Bool {
        get {
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
    }
    init(view: AreaFilterView, interactor: AreaFilterUsecase, router: AreaFilterWireframe) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension AreaFilterPresenter: AreaFilterPresentaion {
    func viewDidLoad() {
        view?.reloadView(isAllCheck: isAllCheck)
    }
    
    func didSelectArea(at indexPath: IndexPath) {
        let areaType = tableDataList[indexPath.row]
        if let index = selectedAreaTypes.index(of: areaType) {
            selectedAreaTypes.remove(at: index)
        } else {
            selectedAreaTypes.append(areaType)
        }
        view?.reloadView(isAllCheck: isAllCheck)
    }
    
    func didTapAllCheckButton(_ button: UIButton) {
        let isCheck = isAllCheck
        selectedAreaTypes.removeAll()
        if !isCheck {
            selectedAreaTypes.append(contentsOf: tableDataList)
        }
        view?.reloadView(isAllCheck: isAllCheck)
    }
}

extension AreaFilterPresenter: AreaFilterInteractorDelegate {
    
}
