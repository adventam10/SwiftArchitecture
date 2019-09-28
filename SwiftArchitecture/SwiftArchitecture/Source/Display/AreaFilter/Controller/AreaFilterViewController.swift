//
//  AreaFilterViewController.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit

protocol AreaFilterViewControllerDelegate: AnyObject {
    
    func areaFilterViewController(_ areaFilterViewController: AreaFilterViewController,
                                  didSelect areaTypes: [AreaFilterModel.Area])
}

final class AreaFilterViewController: UIViewController {
    
    weak var delegate: AreaFilterViewControllerDelegate?
    private let cellIdentifier = "AreaFilterTableViewCell"
    let model = AreaFilterModel()
    private let areaFilterView = AreaFilterView()
    static let viewSize = CGSize.init(width: 150, height: 396)
    override func loadView() {
        self.view = areaFilterView
        areaFilterView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        areaFilterView.displayAllCheckButton(isSelected: model.isAllCheck())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableView() {
        areaFilterView.tableView.delegate = self
        areaFilterView.tableView.dataSource = self
        areaFilterView.tableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                                              forCellReuseIdentifier: cellIdentifier)
    }
}

extension AreaFilterViewController: AreaFilterViewDelegate {
    
    func areaFilterView(_ areaFilterView: AreaFilterView,
                        didTapAllCheck button: UIButton) {
        model.setupSelectedAreaTypes(isAllCheck: !model.isAllCheck())
        areaFilterView.displayAllCheckButton(isSelected: model.isAllCheck())
        areaFilterView.tableView.reloadData()
        delegate?.areaFilterViewController(self, didSelect: model.selectedAreaTypes)
    }
}

extension AreaFilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let areaType = model.tableDataList[indexPath.row]
        model.setupSelectedAreaTypes(areaType: areaType)
        areaFilterView.displayAllCheckButton(isSelected: model.isAllCheck())
        tableView.reloadRows(at: [indexPath], with: .none)
        delegate?.areaFilterViewController(self, didSelect: model.selectedAreaTypes)
    }
}

extension AreaFilterViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.tableDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AreaFilterTableViewCell
        cell.title = model.tableDataList[indexPath.row].getName()
        cell.isCheck = model.selectedAreaTypes.contains(model.tableDataList[indexPath.row])
        return cell
    }
}
