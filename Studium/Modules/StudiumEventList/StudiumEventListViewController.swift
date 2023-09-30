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
    
    // TODO: Docstrings
    let databaseService: DatabaseService! = DatabaseService.shared
    
    // TODO: Docstrings
    let studiumEventService: StudiumEventService = StudiumEventService.shared
    
    // TODO: Docstrings
    var searchController: UISearchController!

    //TODO: Docstrings
    var eventsArray: [[StudiumEvent]] = [[],[]]
    
    var displayedEvents: [[StudiumEvent]] {
        get { self.searchController.isActive ? self.filteredEvents : self.eventsArray }
        set {
            if self.searchController.isActive {
                self.filteredEvents = newValue
            } else {
                self.eventsArray = newValue
            }
        }
    }

    lazy var filteredEvents: [[StudiumEvent]] = self.eventsArray
    
    //TODO: Docstrings
    var sectionHeaders: [String] = ["Section 1", "Section 2"]
    
    //TODO: Docstrings
    var eventTypeString: String = "Events"
    
    lazy var emptyDetailIndicatorViewModel: ImageDetailViewModel = {
        ImageDetailViewModel(image: nil, title: "", subtitle: "", buttonText: "", buttonAction: {})
    }()
    
    private var hostingController: UIHostingController<ImageDetailView>?
    
    override func loadView() {
        super.loadView()
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = self.searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the color of the navigation bar button text
        self.navigationController?.navigationBar.tintColor = StudiumColor.secondaryAccent.uiColor
        self.navigationController?.navigationBar.barTintColor = StudiumColor.background.uiColor
        
        self.navigationItem.title = self.eventTypeString
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.backgroundColor = StudiumColor.background.uiColor
        UINavigationBar.appearance().backgroundColor = StudiumColor.background.uiColor
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
            
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = StudiumColor.background.uiColor
        
        //Register all UI Elements used in the TableView
        self.tableView.register(HeaderView.self, forHeaderFooterViewReuseIdentifier: HeaderView.id)
        self.tableView.register(UINib(nibName: DEPRECATEDRecurringEventCell.id, bundle: nil), forCellReuseIdentifier: DEPRECATEDRecurringEventCell.id)
        self.tableView.register(RecurringEventTableViewCell.self, forCellReuseIdentifier: RecurringEventTableViewCell.id)

        self.tableView.register(OtherEventTableViewCell.self, forCellReuseIdentifier: OtherEventTableViewCell.id)

        self.tableView.register(AssignmentTableViewCell.self, forCellReuseIdentifier: AssignmentTableViewCell.id)

        self.view.backgroundColor = StudiumColor.background.uiColor
        
        // Set the color of the navigation bar title text
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
//        self.navigationController?.navigationBar.backgroundColor = StudiumColor.primaryAccent.uiColor


        


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
        let headerView  = self.tableView.headerView(forSection: section) as? HeaderView
        headerView?.setTexts(
            primaryText: sectionHeaders[section],
            secondaryText: "\(eventsArray[section].count) \(eventTypeString)"
        )
    }
    
    // MARK: - Delete
    
    //TODO: Docstrings
    func delete(at indexPath: IndexPath) {
        Log.d("Will attempt to delete at \(indexPath)")
        if let cell = self.tableView.cellForRow(at: indexPath) as? DeletableEventCell,
           let event = cell.event {
            let eventID = event._id
            let eventType = type(of: event)
            DispatchQueue.global(qos: .userInitiated).async {
                if let event = self.databaseService.getStudiumEvent(withID: eventID, type: eventType.self) {
                    self.studiumEventService.deleteStudiumEvent(event)
                } else {
                    Log.e("Failed to retrieve studiumEvent by ID to delete it.", additionalDetails: "Event type: \(eventType)")
                    PopUpService.presentGenericError()
                }
            }
        }
        
        self.displayedEvents[indexPath.section].remove(at: indexPath.row)
        self.updateHeader(section: indexPath.section)
        self.updateEmptyEventsIndicator()
    }
    
    // MARK: - Edit
    
    //TODO: Docstrings
    func edit(at indexPath: IndexPath) { }

    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.eventsArray[0].isEmpty && self.eventsArray[1].isEmpty ? 0 : super.tableView(tableView, heightForHeaderInSection: section)
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

    // MARK: - TableView DataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.displayedEvents.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayedEvents[section].count
    }
}

extension StudiumEventListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredEvents = [[], []]
        if let searchText = searchController.searchBar.text {
            self.filterEvents(for: searchText)
        }
    }
    
    func filterEvents(for searchText: String) {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.filteredEvents = self.eventsArray
        } else {
            for section in 0..<self.eventsArray.count {
                for event in self.eventsArray[section] {
                    if self.eventIsVisible(event: event, fromSearch: searchText) {
                        self.filteredEvents[section].append(event)
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    func eventIsVisible(event: StudiumEvent, fromSearch searchText: String) -> Bool {
        return event.eventIsVisible(fromSearch: searchText)
    }
}
