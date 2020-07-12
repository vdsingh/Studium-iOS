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
    
    var allEvents: [StudiumEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AssignmentCell", bundle: nil), forCellReuseIdentifier: "AssignmentCell")
        tableView.register(UINib(nibName: "OtherEventCell", bundle: nil), forCellReuseIdentifier: "OtherEventCell")

        //loadAssignments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshData()
    }
    
    func refreshData(){
        allEvents = []
        let assignments = getAssignments()
        let otherEvents = getOtherEvents()
        
        for assignment in assignments{
            allEvents.append(assignment)
        }
        for otherEvent in otherEvents{
            allEvents.append(otherEvent)
        }
        tableView.reloadData()
    }

    func getAssignments() -> Results<Assignment>{
        assignments = realm.objects(Assignment.self) //fetching all objects of type Course and updating array with it.
        return assignments!
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
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("all events: \(allEvents)")
        print("\(allEvents[indexPath.row] is Assignment)")
        if allEvents[indexPath.row] is Assignment {
            super.idString = "AssignmentCell"
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! AssignmentCell
            let assignment = allEvents[indexPath.row] as! Assignment
            cell.loadData(assignment: assignment)
            return cell
        }else if allEvents[indexPath.row] is OtherEvent{
            super.idString = "OtherEventCell"
            let cell = super.tableView(tableView, cellForRowAt: indexPath) as! OtherEventCell
            let otherEvent = allEvents[indexPath.row] as! OtherEvent
            cell.loadData(from: otherEvent)
            return cell
        }else{
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            return cell
        }
//        if indexPath.row < assignments!.count{
//            if let assignment = assignments?[indexPath.row]{
//                let assignmentCell = cell as! AssignmentCell
//                assignmentCell.loadData(assignment: assignment)
//                return assignmentCell
//            }
//        }else{
//            if let otherEvent = otherEvents?[indexPath.row]{
//                let otherEventCell = cell as! OtherEventCell
//                otherEventCell.loadData(from: otherEvent)
//                return otherEventCell
//            }
//        }
        //return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if assignments != nil && otherEvents != nil{
        return assignments!.count + otherEvents!.count
        }else{
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? AssignmentCell{
            if let assignment = cell.assignment{
                do{
                    try realm.write{
                        assignment.complete = !assignment.complete
                    }
                }catch{
                    print(error)
                }
            }
        }else{
            if let cell = tableView.cellForRow(at: indexPath) as? OtherEventCell{
                let otherEvent = cell.otherEvent
                do{
                    try realm.write{
                        otherEvent!.complete = !otherEvent!.complete
                    }
                }catch{
                    print(error)
                }
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
