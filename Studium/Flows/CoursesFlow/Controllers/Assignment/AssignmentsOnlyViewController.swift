//
//  AssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import ChameleonFramework
import VikUtilityKit
import SwiftUI

/// TableViewController that only displays Assignments
class AssignmentsOnlyViewController: AssignmentsOtherEventsViewController, UISearchBarDelegate, ToDoListRefreshProtocol, Coordinated, Storyboarded {
    
    // TODO: Docstring
    weak var coordinator: CoursesCoordinator?
        
    /// The course that was selected to reach this screen
    var selectedCourse: Course! {
        didSet{
            self.reloadData()
        }
    }
    
    override func loadView() {
        super.loadView()
        self.emptyDetailIndicatorViewModel = ImageDetailViewModel(image: FlatImage.boyWritingInBook.uiImage, title: "No Assignments here yet", subtitle: nil, buttonText: "Add an Assignment", buttonAction: self.addButtonPressed)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Courses"
        self.sectionHeaders = ["To Do:", "Turned In:"]
        self.eventTypeString = "Assignments"
        let viewModel = AcademicAdvisorViewModel(image: nil, title: "Academic Advisor", subtitle: "Finish Setup", buttonText: "Add Office Hours", buttonAction: {})
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let course = self.selectedCourse {
            self.title = course.name
        } else {
            Log.e("course is nil")
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
    
    @objc func gradesButtonPressed() {
        self.coordinator?.showGradesFlow()
    }

    //MARK: - CRUD Methods
    
    /// Loads all non-autoscheduled assignments for the selected course.
    override func loadEvents() {
        
        //TODO: Fix sorting
        let assignments = self.databaseService.getContainedEvents(forContainer: self.selectedCourse)
        Log.d("Loaded assignments: \(assignments.map({ $0.name }))")

        // First array is incomplete events, second array is complete events
        self.eventsArray = [[],[]]
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
        
        self.updateEmptyEventsIndicator()
    }
    
    /// Reloads/sorts the data and refreshes the TableView
    override func reloadData() {
        self.loadEvents()
        self.tableView.reloadData()
    }
    
    private func sortEventsArrays() {
        self.eventsArray[0].sort(by: {$0.endDate < $1.endDate})
        self.eventsArray[1].sort(by: {$0.endDate > $1.endDate})
    }
    
    /// Trigger deletion of event in cell
    /// - Parameter indexPath: The index at which we want to delete an event
    override func delete(at indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath) as! DeletableEventCell
        if let event = cell.event as? Assignment {
            self.handleEventsClose(assignment: event)
            self.studiumEventService.deleteStudiumEvent(event)
        } else {
            Log.e("Tried to delete event at cell (\(indexPath.section), \(indexPath.row)), however its event was nil")
        }
        
//        self.displayedEvents
        self.displayedEvents[indexPath.section].remove(at: indexPath.row)
        self.updateHeader(section: indexPath.section)
    }
    
    /// Trigger editing of event in cell
    /// - Parameter indexPath: The index at which we want to edit an event
    override func edit(at indexPath: IndexPath) {
        let deletableEventCell = self.tableView.cellForRow(at: indexPath) as! DeletableEventCell
        self.unwrapCoordinatorOrShowError()

        //TODO: Fix force unwrap
        if let assignmentForEdit = deletableEventCell.event as? Assignment {
            self.editAssignment(assignmentForEdit)
        } else if let otherEventForEdit = deletableEventCell.event as? OtherEvent {
            self.coordinator?.showEditOtherEventViewController(refreshDelegate: self, otherEventToEdit: otherEventForEdit)
        }
    }
    
    override func editAssignment(_ assignment: Assignment) {
        self.coordinator?.showEditAssignmentViewController(refreshDelegate: self, assignmentToEdit: assignment)
    }
}
