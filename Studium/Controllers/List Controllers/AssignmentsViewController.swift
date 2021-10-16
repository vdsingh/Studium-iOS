//
//  AssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class AssignmentsViewController: SwipeTableViewController, UISearchBarDelegate, AssignmentRefreshProtocol{
    
    
    var assignments: Results<Assignment>?
    var assignmentsArr: [[Assignment]] = [[],[]]
    var sectionTitles: [String] = ["Incomplete","Complete"]
    
//    var openAutoEventsAssignment: Assignment
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCourse: Course? {
        didSet{
            loadAssignments()
        }
    }
    
    override func viewDidLoad() {
        searchBar.delegate = self
        tableView.register(UINib(nibName: "AssignmentCell1", bundle: nil), forCellReuseIdentifier: "AssignmentCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCourse?.color{
            title = selectedCourse!.name
            //searchBar.barTintColor = UIColor(hexString: colorHex)
            
            guard let navBar = navigationController?.navigationBar else {fatalError("nav controller doesnt exist")}
            
            
            if let navBarColor = UIColor(hexString: colorHex){
                //navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.barTintColor = navBarColor
                //navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
            }else{
                print("error")
            }
        }else{
            print("error")
        }
        loadAssignments()
        //reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addAssignmentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
        addAssignmentViewController.selectedCourse = selectedCourse
        addAssignmentViewController.delegate = self
        let navController = UINavigationController(rootViewController: addAssignmentViewController)
        self.present(navController, animated:true, completion: nil)
    }
    
    //MARK: - Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentsArr[section].count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        super.idString = "AssignmentCell"
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! AssignmentCell1
        let assignment = assignmentsArr[indexPath.section][indexPath.row]
        cell.assignment = assignment
        cell.assignmentCollapseDelegate = self
        cell.loadData(assignment: assignment)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let assignment = assignmentsArr[indexPath.section][indexPath.row]
        let assignmentCell = tableView.cellForRow(at: indexPath) as! AssignmentCell1

        if let user = app.currentUser {
            realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
            do{
                try realm.write{
                    if assignmentCell.autoEventsOpen{
                        assignmentCell.collapseButtonPressed(assignmentCell.chevronButton)
                    }
                    assignment.complete = !assignment.complete
                    
                    print("assignment scheduledEvents length: \(assignment.scheduledEvents.count)")
//                    for event in assignment.scheduledEvents{
//                        event.complete = true
//                        print("Marked worktime complete")
//                    }
                    print("user changed assignment \(assignment.name) completeness")
                }
            }catch{
                print("error saving course: \(error)")
            }
        }else{
            print("error accessing user")
        }

        
//        loadAssignments(skipAutos: false)
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
    func loadAssignments(){
        assignments = selectedCourse?.assignments.sorted(byKeyPath: K.sortAssignmentsBy, ascending: true)
//        assignments = selectedCourse?.assignments
        assignmentsArr = [[],[]]
        for assignment in assignments!{
            //skip the autoscheduled events.
            if assignment.isAutoscheduled{
                continue
            }
            if assignment.complete == true && !assignment.isAutoscheduled{
//                if!assignment.isAutoscheduled {
                    assignmentsArr[1].append(assignment)
//                }
            }else{
                assignmentsArr[0].append(assignment)
            }
        }
        reloadData()
    }
    
    func reloadData() {
        assignmentsArr[0].sort(by: {$0.endDate < $1.endDate})
        assignmentsArr[1].sort(by: {$0.endDate > $1.endDate})
        tableView.reloadData()
    }
    
    override func updateModelDelete(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
//        do{
//            if let user = app.currentUser {
//                realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
//                try self.realm.write{
//                    if let assignment = cell.event as? Assignment{
//                        guard let course = assignment.parentCourse else{
//                            print("Error accessing parent course in AssignmentViewController")
//                            return
//                        }
//                        let assignmentIndex = course.assignments.index(of: assignment)
//                        course.assignments.remove(at: assignmentIndex!)
//                        assignment.deleteNotifications()
//                    }
//                    cell.event!.deleteNotifications()
//                    self.realm.delete(cell.event!)
//                }
//            }else{
//                print("error accessing user")
//            }
//        }catch{
//            print("Error deleting OtherEvent")
//        }
        RealmCRUD.deleteAssignment(assignment: cell.event as! Assignment)
        assignmentsArr[indexPath.section].remove(at: indexPath.row)
    }
    
    override func updateModelEdit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        
        let eventForEdit = deletableEventCell.event! as! Assignment
        let addAssignmentViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
        addAssignmentViewController.delegate = self
        addAssignmentViewController.assignment = eventForEdit
        addAssignmentViewController.title = "View/Edit Assignment"
        let navController = UINavigationController(rootViewController: addAssignmentViewController)
        self.present(navController, animated:true, completion: nil)
    }
    
    //MARK: - Search Bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        assignments = selectedCourse?.assignments.sorted(byKeyPath: K.sortAssignmentsBy, ascending: true)
        
        if searchBar.text?.count != 0{
            assignments = assignments?.filter("\(K.sortAssignmentsBy) CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: K.sortAssignmentsBy, ascending: true)
        }
        tableView.reloadData()
    }
}

//This extension ensures that the view controller can handle what happens when user wants to collapsed autoscheduled events.
extension AssignmentsViewController: AssignmentCollapseDelegate{
    func handleOpenAutoEvents(assignment: Assignment) {
        
        let arrayIndex = assignment.complete ? 1 : 0
        print("Handle opening auto events")
        
        if let ind = assignmentsArr[arrayIndex].firstIndex(of: assignment){
            var index = ind + 1
            for auto in assignment.scheduledEvents{
                assignmentsArr[arrayIndex].insert(auto, at: index)
                index += 1
            }
        }else{
            print("- Error accessing assignment when opening auto list events. \(assignment.name) is not in the assignments array.")
        }

        tableView.reloadData()
    }
    
    func handleCloseAutoEvents(assignment: Assignment) {
        print("Handle close auto events")
        
        let arrayIndex = assignment.complete ? 1 : 0
        let index = assignmentsArr[arrayIndex].firstIndex(of: assignment)!

        for _ in assignment.scheduledEvents{
            assignmentsArr[arrayIndex].remove(at: index + 1)
        }
        tableView.reloadData()
    }
    
    
}

