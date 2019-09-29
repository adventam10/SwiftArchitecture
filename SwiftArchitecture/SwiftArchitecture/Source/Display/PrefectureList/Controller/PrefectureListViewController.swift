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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prefectureListView.deselectRow(animated: false)
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
        model.tableDataList = model.filteringCityDataList(isFavoriteFilter: model.isFavoriteFilter)
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
        if let index = model.favoriteCityIds.firstIndex(of: cityData.cityId) {
            model.favoriteCityIds.remove(at: index)
        } else {
            model.favoriteCityIds.append(cityData.cityId)
        }
        model.saveFavoriteList(model.favoriteCityIds)
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
        model.requestWeather(cityId: model.tableDataList[indexPath.row].cityId, completion:
            { [unowned self] result in
                SVProgressHUD.dismiss()
                switch result {
                case .success(let weather):
                    self.showWeatherViewController(weather: weather,
                                                   cityData: self.model.tableDataList[indexPath.row])
                case .failure(let error):
                    UIAlertController.showAlert(viewController: self,
                                                message: error.localizedDescription,
                                                buttonTitle: "閉じる")
                }
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
