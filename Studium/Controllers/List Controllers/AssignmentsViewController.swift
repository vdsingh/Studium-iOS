//
//  AssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import ChameleonFramework

class AssignmentsViewController: SwipeTableViewController, UISearchBarDelegate, AssignmentRefreshProtocol{
    var assignments: [Assignment] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCourse: Course! {
        didSet{
            loadAssignments()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        
        //hide for now
        searchBar.isHidden = true

        sectionHeaders = ["To Do:", "Completed:"]
        eventTypeString = "Assignments"
        
        self.tabBarController?.tabBar.barTintColor = K.themeColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCourse?.color {
            title = selectedCourse.name
            //searchBar.barTintColor = UIColor(hexString: colorHex)
            guard let navBar = navigationController?.navigationBar else {fatalError("nav controller doesnt exist")}
            
            if let navBarColor = UIColor(hexString: colorHex) {
                navBar.barTintColor = navBarColor
            } else {
                print("error")
            }
        }else{
            print("error")
        }
        loadAssignments()
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
        super.idString = K.assignmentCellID
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! AssignmentCell1
        let assignment = eventsArray[indexPath.section][indexPath.row] as! Assignment
        cell.event = assignment
        cell.assignmentCollapseDelegate = self
        cell.loadData(assignment: assignment)
        
        return cell
    }
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignment = eventsArray[indexPath.section][indexPath.row] as! Assignment
        let assignmentCell = tableView.cellForRow(at: indexPath) as! AssignmentCell1

        if let user = app.currentUser {
            realm = DatabaseService.shared.realm
//            realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
            do {
                try realm.write {
                    //if the assignments autoscheduled events list is expanded, collapse it before we mark it complete and move it.
                    if assignmentCell.autoEventsOpen {
                        assignmentCell.collapseButtonPressed(assignmentCell.chevronButton)
                    }
                    assignment.complete = !assignment.complete
                }
            } catch {
                print("ERROR: error saving course: \(error)")
            }
        } else {
            print("ERROR: error accessing user")
        }

        if(assignment.isAutoscheduled){
            tableView.reloadData()
        }else{
            loadAssignments()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - CRUD Methods
    
    //loads all non-autoscheduled assignments by accessing the selected course.
    func loadAssignments() {
        //TODO: Fix sorting
        self.assignments = DatabaseService.shared
            .getAssignments(forCourse: selectedCourse)
//            .sorted(by: K.sortAssignmentsBy)
//            .sorted(byKeyPath: K.sortAssignmentsBy, ascending: true)
//        assignments = selectedCourse?.assignments.
        eventsArray = [[],[]]
        // TODO: Fix force unwrap
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
        reloadData()
    }
    
    func reloadData() {
        eventsArray[0].sort(by: {$0.endDate < $1.endDate})
        eventsArray[1].sort(by: {$0.endDate > $1.endDate})
        tableView.reloadData()
    }
    
    override func updateModelDelete(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        RealmCRUD.deleteAssignment(assignment: cell.event as! Assignment)
        eventsArray[indexPath.section].remove(at: indexPath.row)
        updateHeader(section: indexPath.section)
    }
    
    override func updateModelEdit(at indexPath: IndexPath) {
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
        self.assignments = DatabaseService.shared.getAssignments(forCourse: selectedCourse)
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
extension AssignmentsViewController: AssignmentCollapseDelegate{
    func handleOpenAutoEvents(assignment: Assignment) {
        let arrayIndex = assignment.complete ? 1 : 0
        if let ind = eventsArray[arrayIndex].firstIndex(of: assignment){
            var index = ind + 1
            for auto in assignment.scheduledEvents{
                eventsArray[arrayIndex].insert(auto, at: index)
                index += 1
            }
        }else{
            print("$ Error: problem accessing assignment when opening auto list events. \(assignment.name) is not in the assignments array.")
        }
        tableView.reloadData()
    }

    func handleCloseAutoEvents(assignment: Assignment) {
        let arrayIndex = assignment.complete ? 1 : 0
        let index = eventsArray[arrayIndex].firstIndex(of: assignment)!

        for _ in assignment.scheduledEvents{
            eventsArray[arrayIndex].remove(at: index + 1)
        }
        tableView.reloadData()
    }
    
    //this function just collapses all assignmentCells whose autoscheduled events are expanded. We call this when we are leaving the ToDoList screen, to avoid issues when coming back and loading in data.
    func collapseAllExpandedAssignments(){
        for cell in tableView.visibleCells{
            if let assignmentCell = cell as? AssignmentCell1 {
                if assignmentCell.autoEventsOpen {
                    assignmentCell.collapseButtonPressed(assignmentCell.chevronButton)
                }
            }
        }
    }
}

