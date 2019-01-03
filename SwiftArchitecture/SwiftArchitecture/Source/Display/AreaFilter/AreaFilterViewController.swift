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
                                  didSelect areaTypes: [AreaFilterViewController.Area])
}

class AreaFilterViewController: UIViewController {

    weak var delegate: AreaFilterViewControllerDelegate?
    var selectedAreaTypes: [Area]!
    enum Area: Int {
        case hokkaido = 0
        case tohoku = 1
        case kanto = 2
        case chubu = 3
        case kinki = 4
        case chugoku = 5
        case shikoku = 6
        case kyushu = 7
        func getName() -> String {
            switch self {
            case .hokkaido:
                return "北海道"
            case .tohoku:
                return "東北"
            case .kanto:
                return "関東"
            case .chubu:
                return "中部"
            case .kinki:
                return "近畿"
            case .chugoku:
                return "中国"
            case .shikoku:
                return "四国"
            case .kyushu:
                return "九州"
            }
        }
    }
    
    @IBOutlet private weak var allCheckButton: UIButton!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: cellIdentifier, bundle: nil),
                               forCellReuseIdentifier: cellIdentifier)
        }
    }
    
    private let cellIdentifier = "AreaFilterTableViewCell"
    private var tableDataList: [Area] = [.hokkaido, .tohoku, .kanto, .chubu, .kinki, .chugoku, .shikoku, .kyushu]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        allCheckButton.isSelected = isAllCheck()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func tappedAllCheckButton(_ button: UIButton) {
        button.isSelected = !button.isSelected
        selectedAreaTypes.removeAll()
        if button.isSelected {
            selectedAreaTypes.append(contentsOf: tableDataList)
        }
        tableView.reloadData()
        delegate?.areaFilterViewController(self, didSelect: selectedAreaTypes)
    }
    
    private func isAllCheck() -> Bool {
        if selectedAreaTypes.isEmpty {
            return false
        }
        for areaType in tableDataList {
            if !selectedAreaTypes.contains(areaType) {
                return false
            }
        }
        return true
    }
}

extension AreaFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let areaType = tableDataList[indexPath.row]
        if let index = selectedAreaTypes.index(of: areaType) {
            selectedAreaTypes.remove(at: index)
        } else {
            selectedAreaTypes.append(areaType)
        }
        allCheckButton.isSelected = isAllCheck()
        tableView.reloadRows(at: [indexPath], with: .none)
        delegate?.areaFilterViewController(self, didSelect: selectedAreaTypes)
    }
}

extension AreaFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AreaFilterTableViewCell
        cell.title = tableDataList[indexPath.row].getName()
        cell.isCheck = selectedAreaTypes.contains(tableDataList[indexPath.row])
        return cell
    }
}
