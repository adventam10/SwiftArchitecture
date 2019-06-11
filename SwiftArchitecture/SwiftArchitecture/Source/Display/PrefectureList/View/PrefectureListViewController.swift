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

final class PrefectureListViewController: UIViewController {
    var viewModel: PrefectureListViewModel!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
        }
    }
    @IBOutlet private weak var areaFilterButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueInfo = R.segue.prefectureListViewController.toWeather(segue: segue),
            let (weather, cityData) = sender as? (Weather, CityData) {
            segueInfo.destination.viewModel = viewModel.resolver.resolveWeatherViewModel(weather: weather,
                                                                                         cityData: cityData)
        } else if let segueInfo = R.segue.prefectureListViewController.toAreaFilter(segue: segue),
            let button = sender as? UIButton {
            let viewController = segueInfo.destination
            viewController.viewModel = viewModel.resolver.resolveAreaFilterViewModel(selectedAreaTypes: viewModel.selectedAreaTypes.value)
            viewController.delegate = self
            viewController.preferredContentSize = AreaFilterViewController.popoverSize
            let presentationController = viewController.popoverPresentationController
            presentationController?.delegate = self
            presentationController?.sourceView = button
            presentationController?.sourceRect = button.bounds
        }
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
    
    // MARK: - Button Action
    @IBAction private func tappedFavoriteButton(_ button: UIButton) {
        viewModel.isFavoriteFilter.value.toggle()
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
        viewModel.apiClient.requestWeather(cityId: viewModel.tableDataList.value[indexPath.row].cityId,
                                           success: { [unowned self] weather in
                                            SVProgressHUD.dismiss()
                                            self.performSegue(withIdentifier: R.segue.prefectureListViewController.toWeather,
                                                              sender: (weather: weather, cityData: self.viewModel.tableDataList.value[indexPath.row]))
            },
                                           failure: { [unowned self] message in
                                            SVProgressHUD.dismiss()
                                            UIAlertController.showAlert(viewController: self,
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
