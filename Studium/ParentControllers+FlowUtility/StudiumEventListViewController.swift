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
import SwiftUI

//TODO: Docstrings
class StudiumEventListViewController: SwipeTableViewController, ErrorShowing {
    
//    let coordinator: Coordinator

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
    
    lazy var emptyDetailIndicatorViewModel: ImageDetailViewModel = {
        ImageDetailViewModel(image: nil, title: "", subtitle: "", buttonText: "", buttonAction: {})
    }()
    
    private var hostingController: UIHostingController<ImageDetailView>?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the color of the navigation bar button text
        self.navigationController?.navigationBar.tintColor = StudiumColor.secondaryAccent.uiColor
        self.navigationController?.navigationBar.barTintColor = StudiumColor.background.uiColor
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = StudiumColor.background.uiColor
        
        //Register all UI Elements used in the TableView
        self.tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.id)
        self.tableView.register(UINib(nibName: RecurringEventCell.id, bundle: nil), forCellReuseIdentifier: RecurringEventCell.id)
        self.tableView.register(UINib(nibName: AssignmentCell1.id, bundle: nil), forCellReuseIdentifier: AssignmentCell1.id)
        self.tableView.register(UINib(nibName: OtherEventCell.id, bundle: nil), forCellReuseIdentifier: OtherEventCell.id)

        self.view.backgroundColor = StudiumColor.background.uiColor
        
        // Set the color of the navigation bar title text
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]


        self.navigationItem.title = self.eventTypeString
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.rightActions = [
            SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
                self.delete(at: indexPath)
            }
        ]
        
        self.leftActions = [
            SwipeAction(style: .default, title: "Edit"){ (action, indexPath) in
                self.edit(at: indexPath)
            }
        ]
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addButtonPressed))
        self.navigationItem.rightBarButtonItems = [addButton]
                
        let hostingController = UIHostingController(rootView: ImageDetailView(viewModel: self.emptyDetailIndicatorViewModel))
        self.hostingController = hostingController
        self.addChild(hostingController)
        hostingController.view.backgroundColor = .clear
        if let hostingControllerView = hostingController.view {
            hostingControllerView.translatesAutoresizingMaskIntoConstraints = false
            hostingController.didMove(toParent: self)
            self.tableView.addSubview(hostingControllerView)
            
            NSLayoutConstraint.activate([
                hostingControllerView.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
                hostingControllerView.topAnchor.constraint(equalTo: self.tableView.topAnchor, constant: 50),
                hostingControllerView.leadingAnchor.constraint(equalTo: self.tableView.leadingAnchor),
                hostingControllerView.trailingAnchor.constraint(equalTo: self.tableView.trailingAnchor)
            ])
        }
    }
    
    func hideEmptyDetailIndicator(_ hidden: Bool) {
        self.hostingController?.view.isHidden = hidden
    }
    
    @objc func addButtonPressed() { }
    
    func updateEmptyEventsIndicator() {
        if self.eventsArray[0].isEmpty && self.eventsArray[1].isEmpty {
            self.hideEmptyDetailIndicator(false)
        } else {
            self.hideEmptyDetailIndicator(true)
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
        Log.d("Will attempt to delete at \(indexPath)")
        if let cell = tableView.cellForRow(at: indexPath) as? DeletableEventCell,
           let event = cell.event {
            self.studiumEventService.deleteStudiumEvent(event)
        }
        
        self.eventsArray[indexPath.section].remove(at: indexPath.row)
        self.updateHeader(section: indexPath.section)
        self.updateEmptyEventsIndicator()
    }
    
    // MARK: - Edit
    
    //TODO: Docstrings
    func edit(at indexPath: IndexPath) { }

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
        headerView.setTexts(primaryText: self.sectionHeaders[section], secondaryText: "\(self.eventsArray[section].count) \(self.eventTypeString)")
        
        if self.eventsArray[0].isEmpty && self.eventsArray[1].isEmpty {
            headerView.isHidden = true
        } else {
            headerView.isHidden = false
        }
        
        return headerView
    }
    
    //TODO: Implement
    //TODO: Docstrings
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let eventCell = tableView.cellForRow(at: indexPath) as? DeletableEventCell,
//           let event = eventCell.event {
//            
//            if let assignment = event as? Assignment {
//                self.assignmentWasSelected(assignment: assignment)
//            }
//            
////            if let event = eventCell.event as? CompletableStudiumEvent {
////                self.studiumEventService.markComplete(event, !event.complete)
////            } else {
////                Log.d("event is not completable")
////            }
//        }
//    }
    
//    func assignmentWasSelected(assignment: Assignment) {
//        let vc = AssignmentViewController(
//            assignment: assignment,
//            editButtonPressed: {
//                self.editAssignmentWasSelected(assignment)
//            },
//            deleteButtonPressed: {
//                
//            }
//        )
//    }
//    
//    func editAssignmentWasSelected(_ assignment: Assignment) {
//        
//    }
//    
//    func deleteAssignmentWasSelected() {
//        
//    }

// MARK: - TableView DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.eventsArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventsArray[section].count
    }
}
