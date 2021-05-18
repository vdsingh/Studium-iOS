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
    
    var allEvents: [[StudiumEvent]] = [[],[]]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AssignmentCell1", bundle: nil), forCellReuseIdentifier: "AssignmentCell1")
        tableView.register(UINib(nibName: "OtherEventCell", bundle: nil), forCellReuseIdentifier: "OtherEventCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    func refreshData(){
        allEvents = [[],[]]
        let assignments = getAssignments()
        let otherEvents = getOtherEvents()
        
        for assignment in assignments{
            if assignment.complete{
                allEvents[1].append(assignment)
            }else{
                allEvents[0].append(assignment)
            }
        }
        for otherEvent in otherEvents{
            if otherEvent.complete{
                allEvents[1].append(otherEvent)
            }else{
                allEvents[0].append(otherEvent)
            }
        }
        allEvents[0] = allEvents[0].sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        allEvents[1] = allEvents[1].sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })

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
                        let parentCourse = assignment.parentCourse[0]
                        let assignmentIndex = parentCourse.assignments.index(of: assignment)
                        parentCourse.assignments.remove(at: assignmentIndex!)
                        assignment.deleteNotifications()
                    }
                    cell.event!.deleteNotifications()
                    self.realm.delete(cell.event!)
                }
            }catch{
                print("Error deleting OtherEvent")
            }
        allEvents[indexPath.section].remove(at: indexPath.row)
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
    
    func openAssignmentForm(name: String, location: String, additionalDetails: String, alertTimes: [Int], dueDate: Date){
        let addAssignmentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
        let navController = UINavigationController(rootViewController: addAssignmentViewController)
        addAssignmentViewController.delegate = self
        addAssignmentViewController.fromTodoForm = true
        
        //providing the information from the todo form to the assignment form to be reused.
        addAssignmentViewController.todoFormData[0] = name
        addAssignmentViewController.todoFormData[1] = additionalDetails
        addAssignmentViewController.todoAlertTimes = alertTimes
        addAssignmentViewController.todoDueDate = dueDate
        
        self.present(navController, animated:true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if allEvents[indexPath.section][indexPath.row] is Assignment {
            super.idString = "AssignmentCell1"
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! AssignmentCell1
            let assignment = allEvents[indexPath.section][indexPath.row] as! Assignment
            cell.loadData(assignment: assignment)

            return cell
        }else if allEvents[indexPath.section][indexPath.row] is OtherEvent{
            super.idString = "OtherEventCell"
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! OtherEventCell
            let otherEvent = allEvents[indexPath.section][indexPath.row] as! OtherEvent
            cell.loadData(from: otherEvent)
            return cell
        }else{
            print("created poo cell")
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            return cell
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEvents.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        print("assignmetncell at section \(indexPath.section). row \(indexPath.row)")
        return 70
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "To Do:"
        }else{
            return "Complete: "
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEvents[section].count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AssignmentCell1{
            if let assignment = cell.assignment{
                do{
                    try realm.write{
                        assignment.complete = !assignment.complete
                    }
                }catch{
                    print(error)
                }
            }
        }else if let cell = tableView.cellForRow(at: indexPath) as? OtherEventCell{
            if let otherEvent = cell.otherEvent{
                do{
                    try realm.write{
                        otherEvent.complete = !otherEvent.complete
                    }
                }catch{
                    print(error)
                }
            }
        }
        refreshData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ToDoListViewController: AssignmentRefreshProtocol{
    func loadAssignments() {
        refreshData()
    }
}
