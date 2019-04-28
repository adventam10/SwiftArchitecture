//
//  AreaFilterViewController.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

protocol AreaFilterViewControllerDelegate: class {
    func areaFilterViewController(_ areaFilterViewController: AreaFilterViewController,
                                  didSelect areaTypes: [Area])
}

final class AreaFilterViewController: UIViewController {
    weak var delegate: AreaFilterViewControllerDelegate?
    var viewModel: AreaFilterViewModel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(R.nib.areaFilterTableViewCell)
        }
    }
    @IBOutlet private weak var allCheckButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func bind() {
        viewModel.selectedAreaTypes.producer.startWithValues { [unowned self] _ in
            self.allCheckButton.isSelected = self.viewModel.isAllCheck()
            self.tableView.reloadData()
            self.delegate?.areaFilterViewController(self, didSelect: self.viewModel.selectedAreaTypes.value)
        }
    }
    
    // MARK:- Button Action
    @IBAction private func tappedAllCheckButton(_ button: UIButton) {
        viewModel.setupSelectedAreaTypes(isAllCheck: !viewModel.isAllCheck())
    }
}

extension AreaFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setupSelectedAreaTypes(areaType: viewModel.tableDataList[indexPath.row])
    }
}

extension AreaFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.areaFilterTableViewCell,
                                                 for: indexPath)!
        cell.displayData(viewModel.createCellModel(index: indexPath.row))
        return cell
    }
}
