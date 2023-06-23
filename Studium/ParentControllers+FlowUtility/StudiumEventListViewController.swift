//
//  StudiumEventListViewController.swift
//  Studium
//
//  Created by Vikram Singh on 2/7/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwipeCellKit
import UIKit

//TODO: Docstrings
class StudiumEventListViewController: SwipeTableViewController, ErrorShowing {

    // TODO: Docstrings
    let databaseService: DatabaseServiceProtocol! = DatabaseService.shared
    
    // TODO: Docstrings
    let studiumEventService: StudiumEventService = StudiumEventService.shared
    
    //TODO: Docstrings
    override var debug: Bool {
        false
    }
    
    //TODO: Docstrings
    var eventsArray: [[StudiumEvent]] = [[],[]]
    
    //TODO: Docstrings
    var sectionHeaders: [String] = ["Section 1", "Section 2"]
    
    //TODO: Docstrings
    var eventTypeString: String = "Events"
    
    var emptyDetailIndicator: ImageDetailView = {
        let detail = ImageDetailView()
        return detail
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //Register all UI Elements used in the TableView
        self.tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.id)
        self.tableView.register(UINib(nibName: RecurringEventCell.id, bundle: nil), forCellReuseIdentifier: RecurringEventCell.id)
        self.tableView.register(UINib(nibName: AssignmentCell1.id, bundle: nil), forCellReuseIdentifier: AssignmentCell1.id)
        self.tableView.register(UINib(nibName: OtherEventCell.id, bundle: nil), forCellReuseIdentifier: OtherEventCell.id)

        self.view.backgroundColor = StudiumColor.background.uiColor
        
        // Set the color of the navigation bar title text
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]

        // Set the color of the navigation bar button text
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryAccent.uiColor
        self.navigationController?.navigationBar.barTintColor = StudiumColor.background.uiColor
        self.navigationItem.title = eventTypeString
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.rightActions = [
            SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
                self.delete(at: indexPath)
            }
        ]
        
        self.leftActions = [
            SwipeAction(style: .default, title: "View/Edit"){ (action, indexPath) in
                self.edit(at: indexPath)
            }
        ]
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = addButton
        
        self.tableView.addSubview(self.emptyDetailIndicator)
        NSLayoutConstraint.activate([
            emptyDetailIndicator.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
            emptyDetailIndicator.topAnchor.constraint(equalTo: self.tableView.topAnchor, constant: 40)
        ])
    }
    
    @objc func addButtonPressed() {
        
    }
    
    func updateEmptyEventsIndicator() {
        if eventsArray[0].isEmpty && eventsArray[1].isEmpty {
            self.emptyDetailIndicator.isHidden = false
        } else {
            self.emptyDetailIndicator.isHidden = true
        }
    }

    /// Updates the header for a given section
    /// - Parameter section: The section corresponding to the header that we wish to update
    func updateHeader(section: Int) {
        let headerView  = tableView.headerView(forSection: section) as? HeaderView
        headerView?.setTexts(
            primaryText: sectionHeaders[section],
            secondaryText: "\(eventsArray[section].count) \(eventTypeString)"
        )
    }
    
    // MARK: - Delete
    
    //TODO: Docstrings
    func delete(at indexPath: IndexPath) {
        print("$LOG: will attempt to delete at \(indexPath)")
        if let cell = tableView.cellForRow(at: indexPath) as? DeletableEventCell,
           let event = cell.event {
            self.studiumEventService.deleteStudiumEvent(event)
        }
        
        eventsArray[indexPath.section].remove(at: indexPath.row)
        updateHeader(section: indexPath.section)
        self.updateEmptyEventsIndicator()
    }
    
    // MARK: - Edit
    
    //TODO: Docstrings
    func edit(at indexPath: IndexPath) {
       
    }

// MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return eventsArray[0].isEmpty && eventsArray[1].isEmpty ? 0 : super.tableView(tableView, heightForHeaderInSection: section)
    }

    //TODO: Docstrings
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.id) as? HeaderView
        else {
            Log.e("headerView could not be safely casted to type HeaderView")
            return nil
        }
        
        headerView.tintColor = StudiumColor.secondaryBackground.uiColor
        headerView.primaryLabel.textColor = StudiumColor.primaryLabel.uiColor
        headerView.secondaryLabel.textColor = StudiumColor.primaryLabel.uiColor
        headerView.setTexts(primaryText: sectionHeaders[section], secondaryText: "\(eventsArray[section].count) \(eventTypeString)")
        
        if eventsArray[0].isEmpty && eventsArray[1].isEmpty {
            headerView.isHidden = true
        } else {
            headerView.isHidden = false
        }
        
        return headerView
    }
    
    //TODO: Docstrings
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let eventCell = tableView.cellForRow(at: indexPath) as? DeletableEventCell {
            if let event = eventCell.event as? CompletableStudiumEvent {
                self.studiumEventService.markComplete(event, !event.complete)
            } else {
                print("$LOG: event is not completable")
            }
        }
    }

// MARK: - TableView DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return eventsArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray[section].count
    }
}
