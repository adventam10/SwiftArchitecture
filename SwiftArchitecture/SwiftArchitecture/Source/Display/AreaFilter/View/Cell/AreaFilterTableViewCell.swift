//
//  AreaFilterTableViewCell.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

class AreaFilterTableViewCell: UITableViewCell {
    @IBOutlet private weak var areaLabel: UILabel!
    @IBOutlet private weak var checkImageView: UIImageView!
    
    func displayData(_ viewModel: AreaFilterCellViewModel) {
        areaLabel.text = viewModel.title
        checkImageView.isHighlighted = viewModel.isCheck
    }
}
