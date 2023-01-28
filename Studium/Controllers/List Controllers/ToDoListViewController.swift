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

class ToDoListViewController: SwipeTableViewController, ToDoListRefreshProtocol{
        
    var assignments: Results<Assignment>? //Auto updating array linked to the realm
    var otherEvents: Results<OtherEvent>?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        sectionHeaders = ["To Do:", "Completed:"]
        eventTypeString = "Events"

        
        self.tabBarController?.tabBar.barTintColor = K.themeColor

    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        collapseAllExpandedAssignments()
    }
    
    func refreshData(){
        //eventsArray will contain the information in assignmentsArr. The reason that we need to fill up assignmentsArr is so that the super class, AssignmentHolderList, can handle the expansion and collapse of autoscheduled events around certain assignments.
        eventsArray = [[],[]]

        let assignments = getAssignments()
        let otherEvents = getOtherEvents()
        
        for assignment in assignments{
            if assignment.isAutoscheduled{
                continue
            }
            if assignment.complete{
                eventsArray[1].append(assignment)
            }else{
                eventsArray[0].append(assignment)
            }
        }
        
        for otherEvent in otherEvents{
            if otherEvent.complete{
                eventsArray[1].append(otherEvent)
            }else{
                eventsArray[0].append(otherEvent)
            }
        }
        eventsArray[0] = eventsArray[0].sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        eventsArray[1] = eventsArray[1].sorted(by: { $0.startDate.compare($1.startDate) == .orderedDescending })

        tableView.reloadData()
    }

    func getAssignments() -> Results<Assignment>{
        assignments = realm.objects(Assignment.self) //fetching all objects of type Course and updating array with it.
        return assignments!
    }
    
    override func updateModelDelete(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        do{
            try self.realm.write{
                if let assignment = cell.event as? Assignment{
                    guard let course = assignment.parentCourse else{
                        print("Error accessing parent course in ToDoListViewController")
                        return
                    }
                    
                    //TODO: Force unwrap
                    let assignmentIndex = course.assignments.index(of: assignment)
                    
                    course.assignments.remove(at: assignmentIndex!)
                    //TODO: Fix
//                    assignment.deleteNotifications()
                }
//                cell.event!.deleteNotifications()
                self.realm.delete(cell.event!)
            }
        }catch{
            print("Error deleting OtherEvent")
        }
        eventsArray[indexPath.section].remove(at: indexPath.row)
        updateHeader(section: indexPath.section)
    }
    
    override func updateModelEdit(at indexPath: IndexPath) {
        print("edit called")
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        if let eventForEdit = deletableEventCell.event! as? Assignment{
            let addAssignmentViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
            addAssignmentViewController.delegate = self
            addAssignmentViewController.assignment = eventForEdit
            addAssignmentViewController.title = "View/Edit Assignment"
            let navController = UINavigationController(rootViewController: addAssignmentViewController)
            self.present(navController, animated:true, completion: nil)
        }else if let eventForEdit = deletableEventCell.event! as? OtherEvent{
            print("event is otherevent.")
            let addToDoListEventViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddToDoListEventViewController") as! AddToDoListEventViewController
            addToDoListEventViewController.delegate = self
            addToDoListEventViewController.otherEvent = eventForEdit
            addToDoListEventViewController.title = "View/Edit To-Do Event"
            let navController = UINavigationController(rootViewController: addToDoListEventViewController)
            self.present(navController, animated:true, completion: nil)
        }
    }
    
    func getOtherEvents() -> Results<OtherEvent>{
        otherEvents = realm.objects(OtherEvent.self)
        return otherEvents!
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addToDoListEventViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoListEventViewController") as! AddToDoListEventViewController
        addToDoListEventViewController.delegate = self
        let navController = UINavigationController(rootViewController: addToDoListEventViewController)
        self.present(navController, animated:true, completion: nil)
    }
    
    func openAssignmentForm(name: String, location: String, additionalDetails: String, alertTimes: [AlertOption], dueDate: Date){
        let addAssignmentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
        let navController = UINavigationController(rootViewController: addAssignmentViewController)
        addAssignmentViewController.delegate = self
        addAssignmentViewController.fromTodoForm = true
        
        //providing the information from the todo form to the assignment form to be reused.
        addAssignmentViewController.todoFormData[0] = name
        addAssignmentViewController.todoFormData[1] = additionalDetails
        addAssignmentViewController.alertTimes = alertTimes
        addAssignmentViewController.todoDueDate = dueDate
        
        self.present(navController, animated:true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if eventsArray[indexPath.section][indexPath.row] is Assignment {
            super.idString = "AssignmentCell1"
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! AssignmentCell1
            let assignment = eventsArray[indexPath.section][indexPath.row] as! Assignment
            
            cell.assignmentCollapseDelegate = self
            cell.loadData(assignment: assignment)

            return cell
        }else if eventsArray[indexPath.section][indexPath.row] is OtherEvent{
            super.idString = "OtherEventCell"
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! OtherEventCell
            let otherEvent = eventsArray[indexPath.section][indexPath.row] as! OtherEvent
            cell.loadData(from: otherEvent)
            return cell
        }else{
            print("created poo cell")
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            return cell
        }
    }
    

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        print("assignmetncell at section \(indexPath.section). row \(indexPath.row)")
        return 60
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        let headerCell = tableView.dequeueReusableCell(withIdentifier: K.headerCellID) as! HeaderView
//        let headerView = HeaderView()
//        headerView.setTexts(primaryText: sectionHeaders[section], secondaryText: "\(eventsArray[section].count) Events")
//        headerViews[section] = headerView
//
//        return headerView
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let assignmentCell = tableView.cellForRow(at: indexPath) as? AssignmentCell1{
            if let assignment = assignmentCell.event as? Assignment{
                if let user = app.currentUser {
                    realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
                    do{
                        try realm.write{
                            if assignmentCell.autoEventsOpen{
                                assignmentCell.collapseButtonPressed(assignmentCell.chevronButton)
                            }
                            assignment.complete = !assignment.complete
                        }
                    }catch{
                        print("ERROR: error marking assignment complete")
                    }
                }else{
                    print("ERROR: error accessing user")
                }
                
                //if the assignment is autoscheduled, we don't want to call loadAssignments() because all autoscheduled events will be removed from the data, and thus the tableView. We'll have index and UI issues.
                if(assignment.isAutoscheduled){
                    tableView.reloadData()
                }else{
//                    loadAssignments()
                    refreshData()
                }
            }
        }else if let cell = tableView.cellForRow(at: indexPath) as? OtherEventCell{
            print("Selected an otherEventCell")
            if let otherEvent = cell.otherEvent{
                do{
                    try realm.write{
                        otherEvent.complete = !otherEvent.complete
                    }
                }catch{
                    print(error)
                }
            }else{
                print("ERROR: otherEvent from otherEventCell was not assigned - is nil")
            }
            tableView.reloadData()
            refreshData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ToDoListViewController: AssignmentRefreshProtocol{
    func loadAssignments() {
        refreshData()
    }
}

extension ToDoListViewController: AssignmentCollapseDelegate{
    func handleOpenAutoEvents(assignment: Assignment) {
        let arrayIndex = assignment.complete ? 1 : 0
        
        if let ind = eventsArray[arrayIndex].firstIndex(of: assignment){
            var index = ind + 1
            for auto in assignment.scheduledEvents{
                eventsArray[arrayIndex].insert(auto, at: index)
                index += 1
            }
        }else{
            print("ERROR: problem accessing assignment when opening auto list events. \(assignment.name) is not in the assignments array.")
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
            if let assignmentCell = cell as? AssignmentCell1{

                if assignmentCell.autoEventsOpen{
                    assignmentCell.collapseButtonPressed(assignmentCell.chevronButton)
                }
            }
        }
    }
}
