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

class StudiumEventListViewController: SwipeTableViewController {
    var debug = false
    
    var eventsArray: [[StudiumEvent]] = [[],[]]
    
    var sectionHeaders: [String] = ["Section 1", "Section 2"]
    var eventTypeString: String = "Events"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = eventTypeString
        
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.id)
        tableView.register(UINib(nibName: RecurringEventCell.id, bundle: nil), forCellReuseIdentifier: RecurringEventCell.id)
        tableView.register(UINib(nibName: AssignmentCell1.id, bundle: nil), forCellReuseIdentifier: AssignmentCell1.id)
        tableView.register(UINib(nibName: OtherEventCell.id, bundle: nil), forCellReuseIdentifier: OtherEventCell.id)
        
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
    }
    
    func updateHeader(section: Int){
        let headerView  = tableView.headerView(forSection: section) as? HeaderView
        headerView?.setTexts(
            primaryText: sectionHeaders[section],
            secondaryText: "\(eventsArray[section].count) \(eventTypeString)"
        )
    }
    
    // MARK: - Delete
    func delete(at indexPath: IndexPath) {
        print("$Log: will attempt to delete at \(indexPath)")
        if let cell = tableView.cellForRow(at: indexPath) as? DeletableEventCell,
           let event = cell.event {
            DatabaseService.shared.deleteStudiumObject(event)
        }
        
        eventsArray[indexPath.section].remove(at: indexPath.row)
        updateHeader(section: indexPath.section)
    }
    
    // MARK: - Edit
    func edit(at indexPath: IndexPath){
       
    }
}

// MARK: - TableView Delegate

extension StudiumEventListViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.id) as? HeaderView
        else {
            return nil
        }
        
        headerView.setTexts(primaryText: sectionHeaders[section], secondaryText: "\(eventsArray[section].count) \(eventTypeString)")
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let eventCell = tableView.cellForRow(at: indexPath) as? DeletableEventCell {
            if let event = eventCell.event as? CompletableStudiumEvent {
                DatabaseService.shared.markComplete(event, !event.complete)
            } else {
                print("$Log: event is not completable")
            }
        } else {
            print("$Error: Event is not deletable")
        }
    }
}

// MARK: - TableView DataSource

extension StudiumEventListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return eventsArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray[section].count
    }
}

extension StudiumEventListViewController: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (\(String(describing: self)): \(message)")
        }
    }
}
