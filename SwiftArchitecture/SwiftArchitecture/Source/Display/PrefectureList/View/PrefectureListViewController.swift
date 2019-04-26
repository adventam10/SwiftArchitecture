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
    private let viewModel = PrefectureListViewModel()
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(R.nib.prefectureListTableViewCell)
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet private weak var areaFilterButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavigation()
        bind()
        viewModel.isFavoriteFilter.value = viewModel.isFavoriteFilter.value
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
    
    private func setupNavigation() {
        self.navigationItem.title = "お天気"
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "戻る",
                                                                     style: .plain,
                                                                     target: nil,
                                                                     action: nil)
    }
    
    private func bind() {
        viewModel.tableDataList.producer.startWithValues { [unowned self] tableDataList in
            self.noDataView.isHidden = !tableDataList.isEmpty
            self.tableView.reloadData()
        }
        viewModel.isFavoriteFilter.producer.startWithValues { [unowned self] isFavoriteFilter in
            self.favoriteButton.isSelected = isFavoriteFilter
            self.viewModel.setupTableDataList()
        }
        viewModel.selectedAreaTypes.producer.startWithValues { [unowned self] _ in
            self.viewModel.setupTableDataList()
        }
        viewModel.favoriteCityIds.producer.startWithValues { [unowned self] _ in
            self.viewModel.setupTableDataList()
        }
    }
    
    // MARK:- Button Action
    @IBAction private func tappedFavoriteButton(_ button: UIButton) {
        viewModel.isFavoriteFilter.value.toggle()
    }
    
    @IBAction private func tappedAreaFilterButton(_ button: UIButton) {
        showAreaFilterViewController(button: button)
    }
    
    // MARK:- Show
    private func showAreaFilterViewController(button: UIButton) {
        let viewController = AreaFilterViewController()
        viewController.viewModel = viewModel.createAreaFilterViewModel(viewModel.selectedAreaTypes.value)
        viewController.delegate = self
        showPopover(viewController: viewController,
                    sourceView: button,
                    viewSize: viewController.view.frame.size,
                    direction: .up,
                    delegate: self)
    }
    
    private func showWeatherViewController(weather: Weather, cityData: CityData) {
        let viewController = WeatherViewController()
        viewController.viewModel = WeatherViewModel(weather: weather, cityData: cityData)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension PrefectureListViewController: PrefectureListTableViewCellDelegate {
    func prefectureListTableViewCell(_ cell: PrefectureListTableViewCell,
                                     didTapFavorite button: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let cityData = viewModel.tableDataList.value[indexPath.row]
        viewModel.setupFavoriteList(cityId: cityData.cityId)
    }
}

extension PrefectureListViewController: AreaFilterViewControllerDelegate {
    func areaFilterViewController(_ areaFilterViewController: AreaFilterViewController,
                                  didSelect areaTypes: [Area]) {
        viewModel.selectedAreaTypes.value = areaTypes
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
        WeatherViewModel.requestWeather(cityId: viewModel.tableDataList.value[indexPath.row].cityId,
                                             success:
            {[weak self] (weather) in
                SVProgressHUD.dismiss()
                guard let weakSelf = self else { return }
                weakSelf.showWeatherViewController(weather: weather,
                                                   cityData: weakSelf.viewModel.tableDataList.value[indexPath.row])
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
        return viewModel.tableDataList.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.prefectureListTableViewCell,
                                                 for: indexPath)!
        cell.delegate = self
        cell.displayCityData(viewModel.createCellViewModel(index: indexPath.row))
        return cell
    }
}
