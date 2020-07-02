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

class CoursesViewController: SwipeTableViewController, CourseRefreshProtocol {
    
    //let realm = try! Realm() //Link to the realm where we are storing information
    var courses: Results<Course>? //Auto updating array linked to the realm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CourseCell", bundle: nil), forCellReuseIdentifier: "Cell")


        loadCourses()
        
        
        tableView.delegate = self //setting delegate class for the table view to be this
        tableView.dataSource = self //setting data source for the table view to be this
        
        tableView.rowHeight = 100
        //tableView.separatorStyle = .none //gets rid of dividers between cells.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadCourses()
        let navBar = navigationController?.navigationBar
        navBar!.barTintColor = UIColor.systemBackground
        //print(UIColor.gray)
        
        //searchBar.barTintColor = UIColor(hexString: colorHex)
        
//        guard let navBar = navigationController?.navigationBar else {fatalError("nav controller doesnt exist")}
//        navBar.barTintColor = UIColor.gray
    }
    override func viewDidAppear(_ animated: Bool) {
        loadCourses()
    }
    
    
    //MARK: - Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //build the cells
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! CourseCell
        if let course = courses?[indexPath.row]{
            cell.course = course
            cell.deloadData()
            cell.loadData(courseName: course.name, location: course.location, startTime: course.startDate, endTime: course.endDate, days: course.days, iconHex: course.color, course: course)
        }
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        //loadCourses()
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
        if let destinationVC = segue.destination as? AssignmentsViewController {
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCourse = courses?[indexPath.row]
            }
        }
        
    }
    
    //MARK: - CRUD Methods
    func loadCourses(){
        courses = realm.objects(Course.self) //fetching all objects of type Course and updating array with it.
        tableView.reloadData()
        
    }
    
//    override func updateModelDelete(at indexPath: IndexPath) {
//        if let courseForDeletion = courses?[indexPath.row]{
//            do{
//                try realm.write{
//                    realm.delete(courseForDeletion)
//                }
//            }catch{
//                print(error)
//            }
//        }
//    }
    
    override func updateModelEdit(at indexPath: IndexPath) {
        let editCourseViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddCourseViewController") as! AddCourseViewController
        editCourseViewController.delegate = self
        let navController = UINavigationController(rootViewController: editCourseViewController)
        let courseCell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as! CourseCell

        self.present(navController, animated: true) {
            editCourseViewController.loadData(from: courseCell.course!)
        }

    }
    //MARK: - UI Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addCourseViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddCourseViewController") as! AddCourseViewController
        addCourseViewController.delegate = self
        let navController = UINavigationController(rootViewController: addCourseViewController)
        self.present(navController, animated:true, completion: nil)
        
    }
}
