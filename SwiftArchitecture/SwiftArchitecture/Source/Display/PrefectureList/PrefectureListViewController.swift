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
    let USER_DEFAULTS_FAVORITES_KEY = "USER_DEFAULTS_FAVORITES_KEY"
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                               forCellReuseIdentifier: cellIdentifier)
            tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet private weak var areaFilterButton: UIButton!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private var noDataView: UIView!
    private let cellIdentifier = "PrefectureListTableViewCell"
    private var tableDataList = [CityData]()
    private var cityDataList = [CityData]()
    private var selectedAreaTypes = [AreaFilterViewController.Area]()
    private var favoriteCityIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigation()
        loadCityDataList()
        favoriteCityIds = loadFavoriteList()
        setupTableDataList()
        reloadTableView()
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
        button.isSelected = !button.isSelected
        setupTableDataList()
        reloadTableView()
    }
    
    @IBAction private func tappedAreaFilterButton(_ button: UIButton) {
        showAreaFilterViewController(button: button)
    }
    
    private func showAreaFilterViewController(button: UIButton) {
        let viewController = AreaFilterViewController()
        viewController.selectedAreaTypes = selectedAreaTypes
        viewController.delegate = self
        showPopover(viewController: viewController,
                    sourceView: button,
                    direction: .up,
                    delegate: self)
    }
    
    private func showWeatherViewController(weather: Weather, cityData: CityData) {
        let viewController = WeatherViewController()
        viewController.weather = weather
        viewController.cityData = cityData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func setupNavigation() {
        self.navigationItem.title = "お天気"
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "戻る",
                                                                     style: .plain,
                                                                     target: nil,
                                                                     action: nil)
    }
    
    private func loadCityDataList() {
        guard let filePath = Bundle.main.path(forResource: "CityData", ofType: "json") else {
            return
        }
        guard let data = FileManager.default.contents(atPath: filePath) else {
            return
        }
        
        guard let result = try? JSONDecoder().decode(CityDataList.self, from: data) else {
            return
        }
        if let cityDataList = result.cityDataList {
            self.cityDataList = cityDataList
        }
    }
    
    private func setupTableDataList() {
        tableDataList = cityDataList
        if !selectedAreaTypes.isEmpty {
            let areaTypes = selectedAreaTypes.map { $0.rawValue }
            tableDataList = tableDataList.filter
                {
                    areaTypes.contains($0.area)
            }
        }
        if !favoriteButton.isSelected {
            return
        }
        if favoriteCityIds.isEmpty {
            tableDataList.removeAll()
            return
        }
        tableDataList = tableDataList.filter
            {
                favoriteCityIds.contains($0.cityId)
        }
    }
    
    private func loadFavoriteList() -> [String] {
        if let cityIds = UserDefaults.standard.object(forKey: USER_DEFAULTS_FAVORITES_KEY) as? [String] {
            return cityIds
        }
        return [String]()
    }
    
    private func saveFavoriteList(cityIds: [String]) {
        UserDefaults.standard.set(cityIds, forKey: USER_DEFAULTS_FAVORITES_KEY)
        UserDefaults.standard.synchronize()
    }
    
    private func reloadTableView() {
        noDataView.isHidden = !tableDataList.isEmpty
        tableView.reloadData()
    }
}

extension PrefectureListViewController: PrefectureListTableViewCellDelegate {
    func prefectureListTableViewCell(_ cell: PrefectureListTableViewCell,
                                     didTapFavorite button: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let cityData = tableDataList[indexPath.row]
        if let index = favoriteCityIds.index(of: cityData.cityId) {
            favoriteCityIds.remove(at: index)
        } else {
            favoriteCityIds.append(cityData.cityId)
        }
        saveFavoriteList(cityIds: favoriteCityIds)
        setupTableDataList()
        reloadTableView()
    }
}

extension PrefectureListViewController: AreaFilterViewControllerDelegate {
    func areaFilterViewController(_ areaFilterViewController: AreaFilterViewController,
                                  didSelect areaTypes: [AreaFilterViewController.Area]) {
        selectedAreaTypes = areaTypes
        setupTableDataList()
        reloadTableView()
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
        WeatherViewController.requestWeather(cityId: tableDataList[indexPath.row].cityId,
                                             success:
            {[weak self] (weather) in
                SVProgressHUD.dismiss()
                guard let weakSelf = self else { return }
                weakSelf.showWeatherViewController(weather: weather,
                                                   cityData: weakSelf.tableDataList[indexPath.row])
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
        return tableDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! PrefectureListTableViewCell
        cell.delegate = self
        let cityData = tableDataList[indexPath.row]
        cell.displayCityData(cityData, isFavorite: favoriteCityIds.contains(cityData.cityId))
        return cell
    }
}
