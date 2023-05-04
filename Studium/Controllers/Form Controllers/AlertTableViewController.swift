//
//  AlertTableViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/15/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

// TODO: Docstrings
enum AlertOption: Int, CaseIterable {
    case atTime = 0
    case fiveMin = 5
    case tenMin = 10
    case fifteenMin = 15
    case thirtyMin = 30
    case oneHour = 60
    case twoHour = 120
    case fourHour = 240
    case eightHour = 480
    case oneDay = 1440
    
    var userString: String {
        switch self {
        case .atTime:
            return "At time of event"
        case .fiveMin:
            return "5 minutes before"
        case .tenMin:
            return "10 minutes before"
        case .fifteenMin:
            return "15 minutes before"
        case .thirtyMin:
            return "30 minutes before"
        case .oneHour:
            return "1 hour before"
        case .twoHour:
            return "2 hours before"
        case .fourHour:
            return "4 hours before"
        case .eightHour:
            return "8 hours before"
        case .oneDay:
            return "1 day before"
        }
    }
}

// TODO: Docstrings
protocol AlertTimeHandler {
    func alertTimesWereUpdated(selectedAlertOptions: [AlertOption])
}

// TODO: Docstrings
class AlertTableViewController: UITableViewController {
    
    // TODO: Docstrings
    var delegate: AlertTimeHandler?
    
    // TODO: Docstrings
    let allAlertOptions = AlertOption.allCases
    
    // TODO: Docstrings
    private var selectedAlertOptions: [AlertOption] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: LabelCell.id, bundle: nil), forCellReuseIdentifier: LabelCell.id)
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - Private Functions
    
    // TODO: Docstrings
    private func alertOptionIsSelected(alertOption: AlertOption) -> Bool {
        return self.selectedAlertOptions.contains(alertOption)
    }
    
    // MARK: - Public Functions
    
    // TODO: Docstrings
    func setSelectedAlertOptions(alertOptions: [AlertOption]) {
        self.selectedAlertOptions = alertOptions
        self.tableView.reloadData()
    }
}

// MARK: - TableView Setup
extension AlertTableViewController {
    
    // TODO: Docstrings
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAlertOptions.count
    }
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alertOption = allAlertOptions[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: LabelCell.id, for: indexPath) as! LabelCell
        cell.label.text = allAlertOptions[indexPath.row].userString
        cell.accessoryType = .none
        
        if self.selectedAlertOptions.contains(alertOption) {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAlertOption = self.allAlertOptions[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)

        if self.alertOptionIsSelected(alertOption: selectedAlertOption) {
            cell?.accessoryType = .none
            self.selectedAlertOptions.removeAll(where: {$0.rawValue == selectedAlertOption.rawValue})
        } else {
            cell?.accessoryType = .checkmark
            self.selectedAlertOptions.append(selectedAlertOption)
        }
        
        
        if let delegate = self.delegate {
            delegate.alertTimesWereUpdated(selectedAlertOptions: self.selectedAlertOptions)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // TODO: Docstrings
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
