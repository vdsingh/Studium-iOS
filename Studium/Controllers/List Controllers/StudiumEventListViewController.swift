//
//  StudiumEventListViewController.swift
//  Studium
//
//  Created by Vikram Singh on 2/7/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class StudiumEventListViewController: SwipeTableViewController {
    var eventsArray: [[StudiumEvent]] = [[],[]]
    
    var sectionHeaders: [String] = ["Section 1", "Section 2"]
    var eventTypeString: String = "Events"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.id)
        tableView.register(UINib(nibName: RecurringEventCell.id, bundle: nil), forCellReuseIdentifier: RecurringEventCell.id)
        tableView.register(UINib(nibName: AssignmentCell1.id, bundle: nil), forCellReuseIdentifier: AssignmentCell1.id)
        tableView.register(UINib(nibName: OtherEventCell.id, bundle: nil), forCellReuseIdentifier: OtherEventCell.id)
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
        if let cell = tableView.cellForRow(at: indexPath) as? DeletableEventCell {
            let event = cell.event
            DatabaseService.shared.deleteStudiumObject(event!)
        }
        eventsArray[indexPath.section].remove(at: indexPath.row)
        updateHeader(section: indexPath.section)
    }
    
    // MARK: - Edit
    func edit(at indexPath: IndexPath){
        print("$Log: edit called")
        if let deletableEventCell = tableView.cellForRow(at: indexPath) as? DeletableEventCell {
            if let assignment = deletableEventCell.event as? Assignment {
                let addAssignmentViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
//                if let self = self as? AssignmentsViewController {
//                    addAssignmentViewController.delegate = self
//                } else {
//                  print("$Error: Self is ")
//                }
                addAssignmentViewController.assignmentEditing = assignment
                addAssignmentViewController.title = "View/Edit Assignment"
                let navController = UINavigationController(rootViewController: addAssignmentViewController)
                self.present(navController, animated:true, completion: nil)
            } else if let otherEvent = deletableEventCell.event! as? OtherEvent {
                print("event is otherevent.")
                let addToDoListEventViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddToDoListEventViewController") as! AddToDoListEventViewController
//                if let self = self as? ToDoListViewController {
//                    addToDoListEventViewController.delegate = self
//                } else {
//                    print("$Log: self is not ToDoListViewController")
//                }
                addToDoListEventViewController.otherEvent = otherEvent
                addToDoListEventViewController.title = "View/Edit To-Do Event"
                let navController = UINavigationController(rootViewController: addToDoListEventViewController)
                self.present(navController, animated:true, completion: nil)
            }
        }
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
