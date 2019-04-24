//
//  AreaFilterViewController.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

protocol AreaFilterViewControllerDelegate: class {
    func areaFilterViewController(_ areaFilterViewController: AreaFilterViewController,
                                  didSelect areaTypes: [Area])
}

class AreaFilterViewController: UIViewController {
    weak var delegate: AreaFilterViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var allCheckButton: UIButton!
    private let cellIdentifier = "AreaFilterTableViewCell"
    let viewModel = AreaFilterViewModel()
    static let viewSize = CGSize.init(width: 150, height: 396)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        displayAllCheckButton(isSelected: viewModel.isAllCheck())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAllCheckButton(isSelected: Bool) {
        allCheckButton.isSelected = isSelected
    }
    
    @IBAction private func tappedAllCheckButton(_ button: UIButton) {
        viewModel.setupSelectedAreaTypes(isAllCheck: !viewModel.isAllCheck())
        displayAllCheckButton(isSelected: viewModel.isAllCheck())
        tableView.reloadData()
        delegate?.areaFilterViewController(self, didSelect: viewModel.selectedAreaTypes)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                                              forCellReuseIdentifier: cellIdentifier)
    }
}

extension AreaFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let areaType = viewModel.tableDataList[indexPath.row]
        viewModel.setupSelectedAreaTypes(areaType: areaType)
        displayAllCheckButton(isSelected: viewModel.isAllCheck())
        tableView.reloadRows(at: [indexPath], with: .none)
        delegate?.areaFilterViewController(self, didSelect: viewModel.selectedAreaTypes)
    }
}

extension AreaFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tableDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AreaFilterTableViewCell
        cell.title = viewModel.tableDataList[indexPath.row].getName()
        cell.isCheck = viewModel.selectedAreaTypes.contains(viewModel.tableDataList[indexPath.row])
        return cell
    }
}
