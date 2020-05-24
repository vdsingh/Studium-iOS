//
//  CoursesViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CoursesViewController: SwipeTableViewController {
    
    let realm = try! Realm() //Link to the realm where we are storing information
    var courses: Results<Course>? //Auto updating array linked to the realm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCourses()
        
        
        tableView.delegate = self //setting delegate class for the table view to be this
        tableView.dataSource = self //setting data source for the table view to be this
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none //gets rid of dividers between cells.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        guard let navBar = navigationController?.navigationBar else {fatalError("nav controller doesnt exist")}
        //        navBar.backgroundColor = UIColor(hexString: "1D9BF6")
        
        //searchBar.barTintColor = UIColor(hexString: colorHex)
        
        guard let navBar = navigationController?.navigationBar else {fatalError("nav controller doesnt exist")}
        
        
        
        navBar.barTintColor = UIColor.gray
        
    }
    
    
    //MARK: - Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //build the cells
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let course = courses?[indexPath.row]{
            print(course.name)
            cell.textLabel?.text = courses?[indexPath.row].name ?? ""
            
            
            //This is color stuff
            guard let courseColor = UIColor(hexString: course.color)else{fatalError()}
            cell.backgroundColor = UIColor(hexString: courses?[indexPath.row].color ?? "000000")
            cell.textLabel?.textColor = ContrastColorOf(courseColor, returnFlat: true)
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses?.count ?? 1
    }
    
    //MARK: - Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.coursesToAssignmentsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AssignmentsViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCourse = courses?[indexPath.row]
        }
    }
    
    //MARK: - CRUD Methods
    func loadCourses(){
        courses = realm.objects(Course.self) //fetching all objects of type Course and updating array with it.
        tableView.reloadData()
    }
    
    func save(course: Course){
        do{
            try realm.write{
                realm.add(course)
            }
        }catch{
            print(error)
        }
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let courseForDeletion = courses?[indexPath.row]{
            do{
                try realm.write{
                    realm.delete(courseForDeletion)
                }
            }catch{
                print(error)
            }
        }
    }
    
    //MARK: - UI Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default){(action) in
            if textField.text != ""{
                
                let newCourse = Course()
                newCourse.name = textField.text!
                newCourse.color = UIColor.randomFlat().hexValue()
                self.save(course: newCourse)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
