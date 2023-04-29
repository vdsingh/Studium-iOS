//
//  AssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import ChameleonFramework

class AssignmentsViewController: StudiumEventListViewController, UISearchBarDelegate, AssignmentRefreshProtocol {
    
    //TODO: map that tells whether an assignment is expanded
//    var assignmentsExpandedMap = [Assignment: Bool]()
    var assignmentsExpandedSet = Set<Assignment>()
    
    override var debug: Bool {
        return true
    }
    

    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCourse: Course! {
        didSet{
            reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.isHidden = true

        self.sectionHeaders = ["To Do:", "Completed:"]
        self.eventTypeString = "Assignments"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        printDebug("viewWillAppear")
        if let course = selectedCourse {
            let color = course.color
            title = selectedCourse.name
            guard let navController = navigationController else {
                fatalError("$ERR: navigation bar doesnt exist")
            }
            
            navController.navigationBar.barTintColor = color
        } else {
            print("$ERR: course is nil")
        }
        
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        collapseAllExpandedAssignments()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addAssignmentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
        addAssignmentViewController.selectedCourse = selectedCourse
        addAssignmentViewController.delegate = self
        let navController = UINavigationController(rootViewController: addAssignmentViewController)
        self.present(navController, animated:true, completion: nil)
    }
    
    //MARK: - Data Source Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.swipeCellId = AssignmentCell1.id
        if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? AssignmentCell1,
           let assignment = eventsArray[indexPath.section][indexPath.row] as? Assignment {
            cell.event = assignment
            cell.assignmentCollapseDelegate = self
            cell.loadData(assignment: assignment)
            cell.setIsExpanded(isExpanded: self.assignmentsExpandedSet.contains(assignment))            
            return cell
        }
        
        fatalError("$ERR: Couldn't dequeue cell for Course List")
    }
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printDebug("Selected row \(indexPath.row)")
        if let assignment = eventsArray[indexPath.section][indexPath.row] as? Assignment,
           let assignmentCell = tableView.cellForRow(at: indexPath) as? AssignmentCell1 {
            self.handleCloseAutoEvents(assignment: assignment)
            DatabaseService.shared.markComplete(assignment, !assignment.complete)
            
            if(assignment.isAutoscheduled) {
                tableView.reloadData()
            } else {
                reloadData()
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            print("$ERR (AssignmentsViewController): couldn't safely cast assignment or its cell")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - CRUD Methods
    
    //loads all non-autoscheduled assignments by accessing the selected course.
    func loadAssignments() {
        //TODO: Fix sorting
//        let assignments = selectedCourse.assignments
        let assignments = DatabaseService.shared.getAssignments(forCourse: selectedCourse)
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
    
    func reloadData() {
        self.loadAssignments()
        eventsArray[0].sort(by: {$0.endDate < $1.endDate})
        eventsArray[1].sort(by: {$0.endDate > $1.endDate})
        tableView.reloadData()
    }
    
    override func delete(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        if let event = cell.event as? Assignment {
            self.handleCloseAutoEvents(assignment: event)
            DatabaseService.shared.deleteStudiumObject(event)
        } else {
            print("$ERR (AssignmentsViewController): Tried to delete event at cell (\(indexPath.section), \(indexPath.row)), however its event was nil")
        }
        
        eventsArray[indexPath.section].remove(at: indexPath.row)
        updateHeader(section: indexPath.section)
    }
    
    override func edit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        
        let eventForEdit = deletableEventCell.event! as! Assignment
        let addAssignmentViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
        addAssignmentViewController.delegate = self
        addAssignmentViewController.assignmentEditing = eventForEdit
        addAssignmentViewController.title = "View/Edit Assignment"
        let navController = UINavigationController(rootViewController: addAssignmentViewController)
        self.present(navController, animated:true, completion: nil)
    }
    
    //MARK: - Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        assignments = selectedCourse?.assignments.sorted(byKeyPath: K.sortAssignmentsBy, ascending: true)
//        self.assignments = DatabaseService.shared.getAssignments(forCourse: selectedCourse)
        //TODO: Fix filter and sorting
        if searchBar.text?.count != 0 {
//            self.assignments = self.assignments
//                .filter("\(K.sortAssignmentsBy) CONTAINS[cd] %@", searchBar.text!)
//                .sorted(byKeyPath: K.sortAssignmentsBy, ascending: true)
        }
        
        tableView.reloadData()
    }
}

//This extension ensures that the view controller can handle what happens when user wants to collapsed autoscheduled events.
extension AssignmentsViewController: AssignmentCollapseDelegate {
    
    func collapseButtonClicked(assignment: Assignment) {
        
        // The assignment is expanded
        if self.assignmentsExpandedSet.contains(assignment) {
            self.handleCloseAutoEvents(assignment: assignment)
            self.assignmentsExpandedSet.remove(assignment)
        } else {
            self.handleOpenAutoEvents(assignment: assignment)
            self.assignmentsExpandedSet.insert(assignment)
        }
    }
    
    func handleOpenAutoEvents(assignment: Assignment) {
        let assignmentSection = assignment.complete ? 1 : 0
        if let assignmentRow = eventsArray[assignmentSection].firstIndex(of: assignment) {
            printDebug("Handling opening auto events for assignment at index (\(assignmentSection), \(assignmentRow))")
            var index = assignmentRow + 1
            for auto in assignment.scheduledEvents {
                eventsArray[assignmentSection].insert(auto, at: index)
                index += 1
            }
        } else {
            print("$ERR (AssignmentsViewController): problem accessing assignment when opening auto list events. \(assignment.name) is not in the assignments array.")
        }
        
        tableView.reloadData()
    }

    func handleCloseAutoEvents(assignment: Assignment) {
        // assignment is not expanded
        if !self.assignmentsExpandedSet.contains(assignment) {
            return
        }
        
        let assignmentSection = assignment.complete ? 1 : 0
        if let assignmentRow = eventsArray[assignmentSection].firstIndex(of: assignment) {
            printDebug("Handling closing auto events for assignment at index (\(assignmentSection), \(assignmentRow))")
            for _ in assignment.scheduledEvents {
                eventsArray[assignmentSection].remove(at: assignmentRow + 1)
            }
        } else {
            print("$ERR (AssignmentsViewController): problem accessing assignment when closing auto list events. \(assignment.name) is not in the assignments array.")
        }
        
        self.assignmentsExpandedSet.remove(assignment)
        
        tableView.reloadData()
    }
    
    //collapses all assignmentCells whose autoscheduled events are expanded. We call this when we are leaving the ToDoList screen, to avoid issues when coming back and loading in data.
    func collapseAllExpandedAssignments(){
        for cell in tableView.visibleCells {
            if let assignmentCell = cell as? AssignmentCell1 {
                guard let assignment = assignmentCell.event as? Assignment else {
                    print("$ERR (AssignmentsViewController): tried to unwrap cell event as assignment but failed. Event: \(String(describing: assignmentCell.event))")
                    continue
                }
                
                self.handleCloseAutoEvents(assignment: assignment)
            }
        }
    }
}
