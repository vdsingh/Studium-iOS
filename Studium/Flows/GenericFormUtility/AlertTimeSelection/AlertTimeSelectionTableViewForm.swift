//
//  AlertTableViewController.swift
//  Studium
//
//  Created by Vikram Singh on 8/15/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit

import TableViewFormKit

// TODO: Docstrings
protocol AlertTimeHandler {
    
    //TODO: Docstrings
    func alertTimesWereUpdated(selectedAlertOptions: [AlertOption])
}

// TableView Form used to select alert times
class AlertTimeSelectionTableViewForm: TableViewForm, Storyboarded {
    
    // TODO: Docstrings
    var delegate: AlertTimeHandler?
    
    // TODO: Docstrings
    let allAlertOptions = AlertOption.allCases
    
    // TODO: Docstrings
    private var selectedAlertOptions: [AlertOption] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.register(UINib(nibName: LabelCell.id, bundle: nil), forCellReuseIdentifier: LabelCell.id)
        self.tableView.tableFooterView = UIView()
        self.view.backgroundColor = StudiumColor.background.uiColor
//        self.tableView.tintColor = StudiumColor.background.uiColor
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
extension AlertTimeSelectionTableViewForm {
    
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
