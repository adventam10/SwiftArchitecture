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
    private let cellIdentifier = "AreaFilterTableViewCell"
    var presenter: AreaFilterPresenter!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var allCheckButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupTableView()
        presenter.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func tappedAllCheckButton(_ button: UIButton) {
        presenter.didTapAllCheckButton(button)
        delegate?.areaFilterViewController(self, didSelect: presenter.selectedAreaTypes)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                                              forCellReuseIdentifier: cellIdentifier)
    }
}

extension AreaFilterViewController: AreaFilterView {
    func reloadView(isAllCheck: Bool) {
        allCheckButton.isSelected = isAllCheck
        tableView.reloadData()
    }
}

extension AreaFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectArea(at: indexPath)
        tableView.reloadRows(at: [indexPath], with: .none)
        delegate?.areaFilterViewController(self, didSelect: presenter.selectedAreaTypes)
    }
}

extension AreaFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tableDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AreaFilterTableViewCell
        cell.title = presenter.tableDataList[indexPath.row].getName()
        cell.isCheck = presenter.selectedAreaTypes.contains(presenter.tableDataList[indexPath.row])
        return cell
    }
}
