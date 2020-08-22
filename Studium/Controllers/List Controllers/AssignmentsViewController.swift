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
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCourse: Course? {
        didSet{
            loadAssignments()
        }
    }
    
    override func viewDidLoad() {
        searchBar.delegate = self
        tableView.register(UINib(nibName: "AssignmentCell", bundle: nil), forCellReuseIdentifier: "AssignmentCell")
        
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! AssignmentCell
        let assignment = assignmentsArr[indexPath.section][indexPath.row]
        cell.assignment = assignment
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
        do{
            try realm.write{
                assignment.complete = !assignment.complete
            }
        }catch{
            print(error)
        }
        
        loadAssignments()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - CRUD Methods
    func loadAssignments(){
        assignments = selectedCourse?.assignments.sorted(byKeyPath: K.sortAssignmentsBy, ascending: true)
        assignmentsArr = [[],[]]
        for assignment in assignments!{
            if assignment.complete == true{
                assignmentsArr[1].append(assignment)
            }else{
                assignmentsArr[0].append(assignment)
            }
        }
        reloadData()
    }
    
    func reloadData() {
        assignmentsArr[0].sort(by: {$0.endDate < $1.endDate})
        assignmentsArr[1].sort(by: {$0.endDate < $1.endDate})
        tableView.reloadData()
    }
    
//    override func updateModelDelete(at indexPath: IndexPath) {
//        print(assignmentsArr)
//
//        let assignmentIndex = assignments?.index(of: assignmentsArr[indexPath.section][indexPath.row])
//        let assignmentForDeletion = assignments?[assignmentIndex!]
//            do{
//                try self.realm.write{
//                    self.realm.delete(assignmentForDeletion!)
//                }
//            }catch{
//                print("ERROR MANE")
//            }
//        assignmentsArr[indexPath.section].remove(at: indexPath.row)
//        print("right before load assignmetns.")
//    }
    override func updateModelDelete(at indexPath: IndexPath) {
           let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
               do{
                   try self.realm.write{
                       self.realm.delete(cell.event!)
                   }
               }catch{
                   print("ERROR MANE")
               }
           assignmentsArr[indexPath.section].remove(at: indexPath.row)
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

