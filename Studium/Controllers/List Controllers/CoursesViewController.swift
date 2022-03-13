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
    
    //2D Course Array that we use to supply data to the tableView. coursesArr[0] are courses that occur today and coursesArr[1] are courses that do not occur today. This is the most up to date data on courses that we have (changes will be made here that might not be made in courses: Results<Course>? until refreshed).
    var coursesArr: [[Course]] = [[],[]]
    
    //Titles for the section headers
    let sectionHeaders = ["Today:", "Not Today:"]
    
    //keep references to the custom headers so that when we want to change their texts, we can do so. The initial elements are just placeholders, to be replaced when the real headers are created
    var headerViews: [HeaderTableViewCell] = [HeaderTableViewCell(), HeaderTableViewCell()]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadCourses()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = .red
        
        
        tableView.register(UINib(nibName: "RecurringEventCell", bundle: nil), forCellReuseIdentifier: "Cell")
        tableView.register(UINib(nibName: "HeaderTableViewCell", bundle: nil), forCellReuseIdentifier: K.headerCellID)

        
        tableView.delegate = self //setting delegate class for the table view to be this
        tableView.dataSource = self //setting data source for the table view to be this
        
        tableView.rowHeight = 140
        tableView.separatorStyle = .none //gets rid of dividers between cells.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let gradient = CAGradientLayer()
        let sizeLength = UIScreen.main.bounds.size.height * 2
        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)

        gradient.frame = defaultNavigationBarFrame

        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]

        UINavigationBar.appearance().setBackgroundImage(self.image(fromLayer: gradient), for: .default)
        loadCourses()
        
    }
    
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)

        layer.render(in: UIGraphicsGetCurrentContext()!)

        let outputImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return outputImage!
    }
    
    
    //MARK: - Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //build the cells
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! RecurringEventCell
        let course = coursesArr[indexPath.section][indexPath.row]
        cell.event = course
        cell.loadData(courseName: course.name, location: course.location, startTime: course.startDate, endTime: course.endDate, days: course.days, colorHex: course.color, recurringEvent: course, systemImageString: course.systemImageString)
    
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coursesArr[section].count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: K.headerCellID) as! HeaderTableViewCell
        headerCell.setTexts(primaryText: sectionHeaders[section], secondaryText: "\(coursesArr[section].count) Courses")
        headerViews[section] = headerCell
        return headerCell
    }
    
    
    
    //updates the headers for the given section to correctly display the number of elements in that section
    func updateHeader(section: Int){
        let headerView = headerViews[section]
        headerView.setTexts(primaryText: sectionHeaders[section], secondaryText: "\(coursesArr[section].count) Courses")
    }
    
    //MARK: - Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.coursesToAssignmentsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AssignmentsViewController {
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCourse = coursesArr[indexPath.section][indexPath.row]
            }
        }
    }
    
    //MARK: - CRUD Methods
    func loadCourses(){
        courses = realm.objects(Course.self) //fetching all objects of type Course and updating array with it.
        coursesArr = [[],[]]
        for course in courses!{
            if course.days.contains(Date().week){
                coursesArr[0].append(course)
            }else{
                coursesArr[1].append(course)
            }
        }
        
        //sort all the habits happening today by startTime (the ones that are first come first in the list)
        coursesArr[0].sort(by: {$0.startDate.format(with: "HH:mm") < $1.startDate.format(with: "HH:mm")})
        tableView.reloadData()
    }
    
    override func updateModelEdit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        
        let eventForEdit = deletableEventCell.event! as! Course
        let addCourseViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddCourseViewController") as! AddCourseViewController
        addCourseViewController.delegate = self
        addCourseViewController.course = eventForEdit
        ColorPickerCell.color = UIColor(hexString: eventForEdit.color)
        addCourseViewController.title = "View/Edit Course"
        let navController = UINavigationController(rootViewController: addCourseViewController)
        self.present(navController, animated:true, completion: nil)
    }
    
    override func updateModelDelete(at indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        let course: Course = cell.event as! Course
        print("LOG: attempting to delete course \(course.name) at section \(indexPath.section) and row \(indexPath.row)")
        RealmCRUD.deleteCourse(course: course)
        coursesArr[indexPath.section].remove(at: indexPath.row)
        updateHeader(section: indexPath.section)
//        tableView.deleteRows(at: [indexPath], with: .automatic)
        
//        tableView.headerView(forSection: indexPath.section)?.contentConfiguration = config
    }
    
    //MARK: - UI Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addCourseViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddCourseViewController") as! AddCourseViewController
        addCourseViewController.delegate = self
        let navController = UINavigationController(rootViewController: addCourseViewController)
        ColorPickerCell.color = .white
        self.present(navController, animated:true, completion: nil)
    }
}
