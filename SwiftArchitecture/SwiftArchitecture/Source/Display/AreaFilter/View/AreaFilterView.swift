//
//  AreaFilterView.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

protocol AreaFilterViewDelegate: class {
    func areaFilterView(_ areaFilterView: AreaFilterView,
                            didTapAllCheck button: UIButton)
}

class AreaFilterView: BaseView {
    weak var delegate: AreaFilterViewDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var allCheckButton: UIButton!
    
    func displayAllCheckButton(isSelected: Bool) {
        allCheckButton.isSelected = isSelected
    }

    @IBAction private func tappedAllCheckButton(_ button: UIButton) {
        delegate?.areaFilterView(self, didTapAllCheck: button)
    }
}
