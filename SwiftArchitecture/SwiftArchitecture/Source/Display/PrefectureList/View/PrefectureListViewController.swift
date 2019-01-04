//
//  PrefectureListViewController.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import SVProgressHUD

class PrefectureListViewController: UIViewController {
    private let cellIdentifier = "PrefectureListTableViewCell"
    var presenter: PrefectureListPresenter!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var areaFilterButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        PrefectureListRouter.assembleModules(view: self)
        setupNavigation()
        setupTableView()
        presenter.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    // MARK:- Button Action
    @IBAction private func tappedFavoriteButton(_ button: UIButton) {
        presenter.didTapFavoriteButton(button)
    }
    
    @IBAction private func tappedAreaFilterButton(_ button: UIButton) {
        presenter.didTapAreaFilterButton(button)
    }
    
    private func setupNavigation() {
        self.navigationItem.title = "お天気"
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "戻る",
                                                                     style: .plain,
                                                                     target: nil,
                                                                     action: nil)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                           forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
    }
}

extension PrefectureListViewController: PrefectureListTableViewCellDelegate {
    func prefectureListTableViewCell(_ cell: PrefectureListTableViewCell,
                                     didTapFavorite button: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        presenter.didTapFavoriteButton(button, indexPath: indexPath)
    }
}


extension PrefectureListViewController: PrefectureListView {
    func reloadView(isFavoriteFilter: Bool, isTableDataNone: Bool) {
        favoriteButton.isSelected = isFavoriteFilter
        noDataView.isHidden = !isTableDataNone
        tableView.reloadData()
    }
}

extension PrefectureListViewController: AreaFilterViewControllerDelegate {
    func areaFilterViewController(_ areaFilterViewController: AreaFilterViewController,
                                  didSelect areaTypes: [Area]) {
        presenter.didSelectAreaTypes(areaTypes)
    }
}

extension PrefectureListViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension PrefectureListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectCityData(at: indexPath)
    }
}

extension PrefectureListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tableDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PrefectureListTableViewCell
        cell.delegate = self
        let cityData = presenter.tableDataList[indexPath.row]
        cell.displayCityData(cityData, isFavorite: presenter.favoriteCityIds.contains(cityData.cityId))
        return cell
    }
}
