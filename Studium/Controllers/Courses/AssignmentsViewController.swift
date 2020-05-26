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
    
    let realm = try! Realm()
    var assignments: Results<Assignment>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var selectedCourse: Course? {
        didSet{
            loadAssignments()
        }
    }
    
    override func viewDidLoad() {
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let colorHex = selectedCourse?.color{
            title = selectedCourse!.name
            //searchBar.barTintColor = UIColor(hexString: colorHex)
            
            guard let navBar = navigationController?.navigationBar else {fatalError("nav controller doesnt exist")}
            
            
            if let navBarColor = UIColor(hexString: colorHex){
                navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
                navBar.barTintColor = navBarColor
                navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
            }
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addAssignmentViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddAssignmentViewController") as! AddAssignmentViewController
        addAssignmentViewController.delegates.append(self)
        self.present(addAssignmentViewController, animated: true, completion: nil)
    }
    
    //MARK: - Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignments?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let assignment = assignments?[indexPath.row]{
            cell.textLabel?.text = assignment.title
            if let color = UIColor(hexString: selectedCourse!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(assignments!.count)){
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
            
            cell.accessoryType = assignment.complete ? .checkmark : .none
        }else{
            cell.textLabel?.text = ""
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    //MARK: - Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let assignment = assignments?[indexPath.row]{
            do{
                try realm.write{
                    assignment.complete = !assignment.complete
                }
            }catch{
                print(error)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - CRUD Methods
    func loadAssignments(){
        assignments = selectedCourse?.assignments.sorted(byKeyPath: K.sortAssignmentsBy, ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let assignmentForDeletion = self.assignments?[indexPath.row]{
            do{
                try self.realm.write{
                    self.realm.delete(assignmentForDeletion)
                }
            }catch{
                print(error)
            }
        }
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

