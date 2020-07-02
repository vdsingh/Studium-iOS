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

class ToDoListViewController: SwipeTableViewController, AssignmentRefreshProtocol{
    
    //let realm = try! Realm() //Link to the realm where we are storing information
    
    var assignments: Results<Assignment>? //Auto updating array linked to the realm
    var otherEvents: Results<OtherEvent>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "AssignmentCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "OtherEventCell", bundle: nil), forCellReuseIdentifier: "Cell")

        //loadAssignments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAssignments()
        loadOtherEvents()
    }
    
    func loadAssignments(){
        assignments = realm.objects(Assignment.self) //fetching all objects of type Course and updating array with it.
        tableView.reloadData()
    }
    
    func loadOtherEvents(){
        otherEvents = realm.objects(OtherEvent.self)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addToDoListEventViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoListEventViewController") as! AddToDoListEventViewController
        addToDoListEventViewController.delegate = self
        let navController = UINavigationController(rootViewController: addToDoListEventViewController)
        self.present(navController, animated:true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.row < assignments!.count{
            if let assignment = assignments?[indexPath.row]{
                let assignmentCell = cell as! AssignmentCell
                assignmentCell.loadData(assignment: assignment)
                return assignmentCell
            }
        }else{
            if let otherEvent = otherEvents?[indexPath.row]{
                let otherEventCell = cell as! OtherEventCell
                otherEventCell.loadData(from: otherEvent)
                return otherEventCell
            }
        }
        return cell
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
