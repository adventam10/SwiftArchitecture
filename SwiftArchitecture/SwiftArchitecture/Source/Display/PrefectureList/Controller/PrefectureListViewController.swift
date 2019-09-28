//
//  PrefectureListViewController.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import SVProgressHUD

final class PrefectureListViewController: UIViewController {
    private let cellIdentifier = "PrefectureListTableViewCell"
    private let model = PrefectureListModel()
    private let prefectureListView = PrefectureListView()
    
    override func loadView() {
        self.view = prefectureListView
        prefectureListView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        setupTableView()
        reloadView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let indexPath = prefectureListView.tableView.indexPathForSelectedRow {
            prefectureListView.tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    private func setupTableView() {
        prefectureListView.tableView.delegate = self
        prefectureListView.tableView.dataSource = self
        prefectureListView.tableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                                              forCellReuseIdentifier: cellIdentifier)
        prefectureListView.tableView.tableFooterView = UIView()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = "お天気"
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "戻る",
                                                                     style: .plain,
                                                                     target: nil,
                                                                     action: nil)
    }
    
    private func reloadView() {
        model.setupTableDataList()
        prefectureListView.displayView(isFavoriteFilter: model.isFavoriteFilter,
                                       isTableDataNone: model.tableDataList.isEmpty)
    }
    
    private func showAreaFilterViewController(button: UIButton) {
        let viewController = AreaFilterViewController()
        viewController.model.selectedAreaTypes = model.selectedAreaTypes
        viewController.delegate = self
        showPopover(viewController: viewController,
                    sourceView: button,
                    viewSize: AreaFilterViewController.viewSize,
                    direction: .up,
                    delegate: self)
    }
    
    private func showWeatherViewController(weather: Weather, cityData: CityData) {
        let viewController = WeatherViewController()
        viewController.model.weather = weather
        viewController.model.cityData = cityData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PrefectureListViewController: PrefectureListViewDelegate {
    func prefectureListView(_ prefectureListView: PrefectureListView,
                            didTapFavorite button: UIButton) {
        model.isFavoriteFilter = !model.isFavoriteFilter
        reloadView()
    }
    
    func prefectureListView(_ prefectureListView: PrefectureListView,
                            didTapAreaFilter button: UIButton) {
        showAreaFilterViewController(button: button)
    }
}

extension PrefectureListViewController: PrefectureListTableViewCellDelegate {
    func prefectureListTableViewCell(_ cell: PrefectureListTableViewCell,
                                     didTapFavorite button: UIButton) {
        guard let indexPath = prefectureListView.tableView.indexPath(for: cell) else {
            return
        }
        let cityData = model.tableDataList[indexPath.row]
        model.setupFavoriteList(cityId: cityData.cityId)
        reloadView()
    }
}

extension PrefectureListViewController: AreaFilterViewControllerDelegate {
    func areaFilterViewController(_ areaFilterViewController: AreaFilterViewController,
                                  didSelect areaTypes: [AreaFilterModel.Area]) {
        model.selectedAreaTypes = areaTypes
        reloadView()
    }
}

extension PrefectureListViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension PrefectureListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SVProgressHUD.show()
        WeatherModel.requestWeather(cityId: model.tableDataList[indexPath.row].cityId,
                                             success:
            {[weak self] (weather) in
                SVProgressHUD.dismiss()
                guard let weakSelf = self else { return }
                weakSelf.showWeatherViewController(weather: weather,
                                                   cityData: weakSelf.model.tableDataList[indexPath.row])
        },
                                             failure:
            {[weak self] (message) in
                SVProgressHUD.dismiss()
                guard let weakSelf = self else { return }
                UIAlertController.showAlert(viewController: weakSelf,
                                            title: "",
                                            message: message,
                                            buttonTitle: "閉じる",
                                            buttonAction: nil)
        })
    }
}

extension PrefectureListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.tableDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PrefectureListTableViewCell
        cell.delegate = self
        let cityData = model.tableDataList[indexPath.row]
        cell.displayCityData(cityData, isFavorite: model.favoriteCityIds.contains(cityData.cityId))
        return cell
    }
}
