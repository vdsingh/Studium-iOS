//
//  AssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import ChameleonFramework

//TODO: Docstrings
class AssignmentsOnlyViewController: AssignmentsViewController, UISearchBarDelegate, AssignmentRefreshProtocol, Coordinated {
    
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

        self.sectionHeaders = ["To Do:", "Completed:"]
        self.eventTypeString = "Assignments"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        printDebug("viewWillAppear")
        if let course = selectedCourse {
            self.title = course.name
        } else {
            print("$ERR: course is nil")
        }
        
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        collapseAllExpandedAssignments()
    }
    
    /// The user pressed the '+' button to add a new assignment
    /// - Parameter sender: The button that the user pressed
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addAssignmentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
        addAssignmentViewController.selectedCourse = selectedCourse
        addAssignmentViewController.delegate = self
        let navController = UINavigationController(rootViewController: addAssignmentViewController)
        self.present(navController, animated:true, completion: nil)
    }
    
    //MARK: - Data Source Methods
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.swipeCellId = AssignmentCell1.id
        if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? AssignmentCell1,
           let assignment = eventsArray[indexPath.section][indexPath.row] as? Assignment {
            cell.event = assignment
            cell.loadData(assignment: assignment, assignmentCollapseDelegate: self)
            cell.setIsExpanded(isExpanded: self.assignmentsExpandedSet.contains(assignment))
            return cell
        }
        
        fatalError("$ERR: Couldn't dequeue cell for Course List")
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - CRUD Methods
    
    //loads all non-autoscheduled assignments by accessing the selected course.
    override func loadAssignments() {
        //TODO: Fix sorting
//        let assignments = selectedCourse.assignments
        let assignments = self.databaseService.getAssignments(forCourse: selectedCourse)
        printDebug("Loaded assignments: \(assignments.map({ $0.name }))")
//        let assignments = DatabaseService.shared
//            .getAssignments(forCourse: self.selectedCourse)
//            .sorted(by: K.sortAssignmentsBy)
//            .sorted(byKeyPath: K.sortAssignmentsBy, ascending: true)
//        assignments = selectedCourse?.assignments.
        self.eventsArray = [[],[]]
        for assignment in assignments {
            
            //skip the autoscheduled events.
            if assignment.isAutoscheduled {
                continue
            }
            
            if assignment.complete == true && !assignment.isAutoscheduled {
                eventsArray[1].append(assignment)
            }else{
                eventsArray[0].append(assignment)
            }
        }
    }
    
    /// Reloads/sorts the data and refreshes the TableView
    override func reloadData() {
        self.loadAssignments()
        eventsArray[0].sort(by: {$0.endDate < $1.endDate})
        eventsArray[1].sort(by: {$0.endDate > $1.endDate})
        tableView.reloadData()
    }
    
    /// Trigger deletion of event in cell
    /// - Parameter indexPath: The index at which we want to delete an event
    override func delete(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        if let event = cell.event as? Assignment {
            self.handleEventsClose(assignment: event)
            self.databaseService.deleteStudiumObject(event)
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
        
        let eventForEdit = deletableEventCell.event! as! Assignment
        self.unwrapCoordinatorOrShowError()
        self.coordinator?.showEditAssignmentViewController(refreshDelegate: self, assignmentToEdit: eventForEdit)
//        let addAssignmentViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
//        addAssignmentViewController.delegate = self
//        addAssignmentViewController.selectedCourse = eventForEdit.parentCourse
//        addAssignmentViewController.assignmentEditing = eventForEdit
//        addAssignmentViewController.title = "View/Edit Assignment"
//        let navController = UINavigationController(rootViewController: addAssignmentViewController)
//        self.present(navController, animated:true, completion: nil)
    }
}
