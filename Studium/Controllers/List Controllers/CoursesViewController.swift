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
    var courses: Results<Course>? //Auto updating array linked to the realm

    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionHeaders = ["Today:", "Not Today:"]
        eventTypeString = "Courses"

        navigationController?.navigationBar.prefersLargeTitles = true
        
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
        let course = eventsArray[indexPath.section][indexPath.row] as! Course
        cell.event = course
        cell.loadData(courseName: course.name, location: course.location, startTime: course.startDate, endTime: course.endDate, days: course.days, colorHex: course.color, recurringEvent: course, systemImageString: course.systemImageString)
    
        return cell
    }
    
    //MARK: - Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.coursesToAssignmentsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AssignmentsViewController {
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCourse = eventsArray[indexPath.section][indexPath.row] as? Course
            }
        }
    }
    
    //MARK: - CRUD Methods
    func loadCourses(){
        courses = realm.objects(Course.self) //fetching all objects of type Course and updating array with it.
        eventsArray = [[],[]]
        for course in courses!{
            if course.days.contains(Date().week){
                eventsArray[0].append(course)
            }else{
                eventsArray[1].append(course)
            }
        }
        
        //sort all the habits happening today by startTime (the ones that are first come first in the list)
        eventsArray[0].sort(by: {$0.startDate.format(with: "HH:mm") < $1.startDate.format(with: "HH:mm")})
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
        eventsArray[indexPath.section].remove(at: indexPath.row)
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
