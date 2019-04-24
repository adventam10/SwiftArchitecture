//
//  PrefectureListViewController.swift
//  SwiftArchitecture
//
//  Created by am10 on 2019/01/02.
//  Copyright © 2019年 am10. All rights reserved.
//

import UIKit
import SVProgressHUD
import ReactiveSwift
import ReactiveCocoa

class PrefectureListViewController: UIViewController {
    private let cellIdentifier = "PrefectureListTableViewCell"
    private let viewModel = PrefectureListViewModel()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet private weak var areaFilterButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private var noDataView: UIView!
    
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
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                                              forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavigation() {
        self.navigationItem.title = "お天気"
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "戻る",
                                                                     style: .plain,
                                                                     target: nil,
                                                                     action: nil)
    }
    
    private func reloadView() {
        viewModel.setupTableDataList()
        displayView(isFavoriteFilter: viewModel.isFavoriteFilter,
                                       isTableDataNone: viewModel.tableDataList.isEmpty)
    }
    
    func displayView(isFavoriteFilter: Bool, isTableDataNone: Bool) {
        favoriteButton.isSelected = isFavoriteFilter
        noDataView.isHidden = !isTableDataNone
        tableView.reloadData()
    }
    
    // MARK:- Button Action
    @IBAction private func tappedFavoriteButton(_ button: UIButton) {
        viewModel.isFavoriteFilter = !viewModel.isFavoriteFilter
        reloadView()
    }
    
    @IBAction private func tappedAreaFilterButton(_ button: UIButton) {
        showAreaFilterViewController(button: button)
    }
    
    private func showAreaFilterViewController(button: UIButton) {
        let viewController = AreaFilterViewController()
        viewController.viewModel.selectedAreaTypes = viewModel.selectedAreaTypes
        viewController.delegate = self
        showPopover(viewController: viewController,
                    sourceView: button,
                    viewSize: AreaFilterViewController.viewSize,
                    direction: .up,
                    delegate: self)
    }
    
    private func showWeatherViewController(weather: Weather, cityData: CityData) {
        let viewController = WeatherViewController()
        viewController.viewModel.weather = weather
        viewController.viewModel.cityData = cityData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PrefectureListViewController: PrefectureListTableViewCellDelegate {
    func prefectureListTableViewCell(_ cell: PrefectureListTableViewCell,
                                     didTapFavorite button: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let cityData = viewModel.tableDataList[indexPath.row]
        viewModel.setupFavoriteList(cityId: cityData.cityId)
        reloadView()
    }
}

extension PrefectureListViewController: AreaFilterViewControllerDelegate {
    func areaFilterViewController(_ areaFilterViewController: AreaFilterViewController,
                                  didSelect areaTypes: [Area]) {
        viewModel.selectedAreaTypes = areaTypes
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
        WeatherViewModel.requestWeather(cityId: viewModel.tableDataList[indexPath.row].cityId,
                                             success:
            {[weak self] (weather) in
                SVProgressHUD.dismiss()
                guard let weakSelf = self else { return }
                weakSelf.showWeatherViewController(weather: weather,
                                                   cityData: weakSelf.viewModel.tableDataList[indexPath.row])
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
        return viewModel.tableDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PrefectureListTableViewCell
        cell.delegate = self
        let cityData = viewModel.tableDataList[indexPath.row]
        cell.displayCityData(cityData, isFavorite: viewModel.favoriteCityIds.contains(cityData.cityId))
        return cell
    }
}
