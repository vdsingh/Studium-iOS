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
class ToDoListViewController: AssignmentsOtherEventsViewController, ToDoListRefreshProtocol, Coordinated, Storyboarded {
    
    weak var coordinator: ToDoCoordinator?
    
    //TODO: Docstrings
    let assignments = [Assignment]()
    
    //TODO: Docstrings
    let otherEvents = [OtherEvent]()
    
    override func loadView() {
        super.loadView()
        self.emptyDetailIndicatorViewModel = ImageDetailViewModel(
            image: FlatImage.womanFlying.uiImage,
            title: "No Events here yet",
            subtitle: nil,
            buttonText: "Add an Event",
            buttonAction: self.addButtonPressed
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "To Do List"
        self.eventTypeString = "Events"
                
        self.sectionHeaders = ["To Do:", "Completed:"]
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
                self.eventsArray[1].append(assignment)
            } else {
                self.eventsArray[0].append(assignment)
            }
            
            // If the Assignment is expanded
            if self.assignmentsExpandedIDSet.contains(assignment._id.stringValue) {
                self.handleEventsOpen(assignment: assignment)
            }
        }
        
        for otherEvent in otherEvents {
            if otherEvent.autoscheduled {
                continue
            }
            
            if otherEvent.complete {
                self.eventsArray[1].append(otherEvent)
            } else {
                self.eventsArray[0].append(otherEvent)
            }
        }
        
        self.updateEmptyEventsIndicator()
    }
    
    //TODO: Docstrings
    override func reloadData() {
        self.loadEvents()
        self.tableView.reloadData()
    }
    
    //TODO: Docstrings
    override func edit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        self.unwrapCoordinatorOrShowError()

        if let assignment = deletableEventCell.event as? Assignment {
            self.editAssignment(assignment)
        } else if let otherEvent = deletableEventCell.event as? OtherEvent {
            self.editOtherEvent(otherEvent)
            Log.d("Attempting to edit OtherEvent: \(otherEvent)")
        } else {
            Log.e("Couldn't cast event as Assignment or OtherEvent when attempting to edit")
            PopUpService.presentGenericError()
        }
    }
    
    override func editAssignment(_ assignment: Assignment) {
        self.coordinator?.showEditAssignmentViewController(refreshDelegate: self, assignmentToEdit: assignment)
    }
    
    override func editOtherEvent(_ otherEvent: OtherEvent) {
        self.coordinator?.showEditOtherEventViewController(refreshDelegate: self, otherEventToEdit: otherEvent)
    }
    
    //TODO: Docstrings
    override func addButtonPressed() {
        self.unwrapCoordinatorOrShowError()
        self.coordinator?.showAddToDoListEventViewController(refreshDelegate: self)
    }
}
