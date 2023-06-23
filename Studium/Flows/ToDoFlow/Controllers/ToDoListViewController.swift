//
//  AllAssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

//TODO: Docstrings
class ToDoListViewController: AssignmentsOtherEventsViewController, ToDoListRefreshProtocol, AssignmentRefreshProtocol, Coordinated, Storyboarded {
    
    // TODO: Docstrings
    override var debug: Bool {
        return false
    }
    
    weak var coordinator: ToDoCoordinator?
    
    //TODO: Docstrings
    let assignments = [Assignment]()
    
    //TODO: Docstrings
    let otherEvents = [OtherEvent]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To Do List"
        self.eventTypeString = "Events"
                
        self.sectionHeaders = ["To Do:", "Completed:"]
        
        self.emptyDetailIndicator.setImage(FlatImage.womanFlying.uiImage)
        self.emptyDetailIndicator.setTitle("No To-Do Events here yet")
        self.emptyDetailIndicator.setSubtitle("Tap + to add a To-Do Event")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.collapseAllExpandedAssignments()
    }
    
    override func loadEvents() {
        self.eventsArray = [[],[]]

        let assignments = self.databaseService.getStudiumObjects(expecting: Assignment.self)
        let otherEvents = self.databaseService.getStudiumObjects(expecting: OtherEvent.self)
        
        for assignment in assignments {
            if assignment.complete {
                eventsArray[1].append(assignment)
            } else {
                eventsArray[0].append(assignment)
            }
        }
        
        for otherEvent in otherEvents {
            if otherEvent.autoscheduled {
                continue
            }
            
            if otherEvent.complete {
                eventsArray[1].append(otherEvent)
            } else {
                eventsArray[0].append(otherEvent)
            }
        }
        
        eventsArray[0] = eventsArray[0].sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        eventsArray[1] = eventsArray[1].sorted(by: { $0.startDate.compare($1.startDate) == .orderedDescending })
        
        self.updateEmptyEventsIndicator()
    }
    
    //TODO: Docstrings
    override func reloadData() {
        self.loadEvents()
        tableView.reloadData()
    }
    
    //TODO: Docstrings
    override func edit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        self.unwrapCoordinatorOrShowError()

        if let assignment = deletableEventCell.event! as? Assignment {
            self.coordinator?.showEditAssignmentViewController(refreshDelegate: self, assignmentToEdit: assignment)
        } else if let otherEvent = deletableEventCell.event! as? OtherEvent {
            self.coordinator?.showEditOtherEventViewController(refreshDelegate: self, otherEventToEdit: otherEvent)
        }
    }
    
    //TODO: Docstrings
    override func addButtonPressed() {
        self.unwrapCoordinatorOrShowError()
        self.coordinator?.showAddToDoListEventViewController(refreshDelegate: self)
    }
}
