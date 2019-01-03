//
//  PrefectureListView.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

protocol PrefectureListViewDelegate: class {
    func prefectureListView(_ prefectureListView: PrefectureListView,
                            didTapFavorite button: UIButton)
    
    func prefectureListView(_ prefectureListView: PrefectureListView,
                            didTapAreaFilter button: UIButton)
}

class PrefectureListView: BaseView {
    weak var delegate: PrefectureListViewDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var areaFilterButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private var noDataView: UIView!
    
    func displayView(isFavoriteFilter: Bool, isTableDataNone: Bool) {
        favoriteButton.isSelected = isFavoriteFilter
        noDataView.isHidden = !isTableDataNone
        tableView.reloadData()
    }
    
    // MARK:- Button Action
    @IBAction private func tappedFavoriteButton(_ button: UIButton) {
        delegate?.prefectureListView(self, didTapFavorite: button)
    }
    
    @IBAction private func tappedAreaFilterButton(_ button: UIButton) {
        delegate?.prefectureListView(self, didTapAreaFilter: button)
    }
}
