//
//  PrefectureListView.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/03.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

protocol PrefectureListViewDelegate: AnyObject {
    
    func prefectureListView(_ prefectureListView: PrefectureListView,
                            didTapFavorite button: UIButton)
    
    func prefectureListView(_ prefectureListView: PrefectureListView,
                            didTapAreaFilter button: UIButton)
}

final class PrefectureListView: BaseView {
    
    weak var delegate: PrefectureListViewDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var areaFilterButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var noDataView: UIView!
    
    func displayView(isFavoriteFilter: Bool, isTableDataNone: Bool) {
        favoriteButton.isSelected = isFavoriteFilter
        noDataView.isHidden = !isTableDataNone
        tableView.reloadData()
    }
    
    func deselectRow(animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    // MARK:- Button Action
    @IBAction private func tappedFavoriteButton(_ button: UIButton) {
        delegate?.prefectureListView(self, didTapFavorite: button)
    }
    
    @IBAction private func tappedAreaFilterButton(_ button: UIButton) {
        delegate?.prefectureListView(self, didTapAreaFilter: button)
    }
}
