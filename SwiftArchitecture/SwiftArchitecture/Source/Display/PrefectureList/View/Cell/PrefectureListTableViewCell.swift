//
//  PrefectureListTableViewCell.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

protocol PrefectureListTableViewCellDelegate: class {
    func prefectureListTableViewCell(_ cell: PrefectureListTableViewCell,
                                     didTapFavorite button: UIButton)
}

class PrefectureListTableViewCell: UITableViewCell {
    weak var delegate: PrefectureListTableViewCellDelegate?
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK:- Button Action
    @IBAction private func tappedFavoriteButton(_ button: UIButton) {
        delegate?.prefectureListTableViewCell(self, didTapFavorite: button)
    }
    
    func displayCityData(_ viewModel: PrefectureListCellViewModel) {
        titleLabel.text = viewModel.cityName
        favoriteButton.isSelected = viewModel.isFavorite
    }
}
