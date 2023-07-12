//
//  AssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import ChameleonFramework



/// TableViewController that only displays Assignments
class AssignmentsOnlyViewController: AssignmentsOtherEventsViewController, UISearchBarDelegate, AssignmentRefreshProtocol, ToDoListRefreshProtocol, Coordinated, Storyboarded {
    
    // TODO: Docstring
    weak var coordinator: CoursesCoordinator?
    
    override var debug: Bool {
        return true
    }
        
    /// The course that was selected to reach this screen
    var selectedCourse: Course! {
        didSet{
            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Courses"
        self.sectionHeaders = ["To Do:", "Completed:"]
        self.eventTypeString = "Assignments"
        
        self.emptyDetailIndicator.setImage(FlatImage.boyWritingInBook.uiImage)
        self.emptyDetailIndicator.setTitle("No Assignments here yet")
        self.emptyDetailIndicator.setSubtitle("Tap + to add an Assignment")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let course = selectedCourse {
            self.title = course.name
        } else {
            print("$ERR: course is nil")
        }
        
        self.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.collapseAllExpandedAssignments()
    }
        
    /// The user pressed the '+' button to add a new assignment
    /// - Parameter sender: The button that the user pressed
    override func addButtonPressed() {
        self.unwrapCoordinatorOrShowError()
        self.coordinator?.showAddAssignmentViewController(refreshDelegate: self, selectedCourse: self.selectedCourse)
    }

    //MARK: - CRUD Methods
    
    /// Loads all non-autoscheduled assignments for the selected course.
    override func loadEvents() {
        
        //TODO: Fix sorting
        let assignments = self.databaseService.getContainedEvents(forContainer: self.selectedCourse)
        printDebug("Loaded assignments: \(assignments.map({ $0.name }))")

        // First array is incomplete events, second array is complete events
        self.eventsArray = [[],[]]
        for assignment in assignments {
            if assignment.complete {
                eventsArray[1].append(assignment)
            } else {
                eventsArray[0].append(assignment)
            }
            
            // If the Assignment is expanded
            if self.assignmentsExpandedSet.contains(assignment) {
                self.handleEventsOpen(assignment: assignment)
            }
        }
        
        self.updateEmptyEventsIndicator()
    }
    
    /// Reloads/sorts the data and refreshes the TableView
    override func reloadData() {
        self.loadEvents()
        tableView.reloadData()
    }
    
    private func sortEventsArrays() {
        self.eventsArray[0].sort(by: {$0.endDate < $1.endDate})
        self.eventsArray[1].sort(by: {$0.endDate > $1.endDate})
    }
    
    /// Trigger deletion of event in cell
    /// - Parameter indexPath: The index at which we want to delete an event
    override func delete(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        if let event = cell.event as? Assignment {
            self.handleEventsClose(assignment: event)
            self.studiumEventService.deleteStudiumEvent(event)
        } else {
            print("$ERR (AssignmentsViewController): Tried to delete event at cell (\(indexPath.section), \(indexPath.row)), however its event was nil")
        }
        
        eventsArray[indexPath.section].remove(at: indexPath.row)
        updateHeader(section: indexPath.section)
    }
    
    /// Trigger editing of event in cell
    /// - Parameter indexPath: The index at which we want to edit an event
    override func edit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        self.unwrapCoordinatorOrShowError()

        if let assignmentForEdit = deletableEventCell.event! as? Assignment {
            self.coordinator?.showEditAssignmentViewController(refreshDelegate: self, assignmentToEdit: assignmentForEdit)
        } else if let otherEventForEdit = deletableEventCell.event! as? OtherEvent {
            self.coordinator?.showEditOtherEventViewController(refreshDelegate: self, otherEventToEdit: otherEventForEdit)
        }
    }
}
