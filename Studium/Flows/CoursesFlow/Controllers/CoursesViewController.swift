//
//  CoursesViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//
import UIKit
import ChameleonFramework

//TODO: Docstrings
class CoursesViewController: StudiumEventListViewController, CourseRefreshProtocol, Storyboarded {
    
    weak var coordinator: CoursesCoordinator?
    
    private enum SegueIdentifiers: String {
        case coursesToAssignments = "coursesToAssignments"
    }
    
    //TODO: Docstrings
    var courses = [Course]()

//    let defaults = UserDefaults.standard
    
    override var debug: Bool {
        false
    }
    
    override func viewDidLoad() {
        self.eventTypeString = "Courses"

        super.viewDidLoad()
        
        sectionHeaders = ["Today:", "Not Today:"]

        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.delegate = self //setting delegate class for the table view to be this
        tableView.dataSource = self //setting data source for the table view to be this
        
        tableView.rowHeight = 140
        tableView.separatorStyle = .none //gets rid of dividers between cells.
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let sizeLength = UIScreen.main.bounds.size.height * 2
//        let defaultNavigationBarFrame = CGRect(x: 0, y: 0, width: sizeLength, height: 64)

        loadCourses()
        
    }
    
    //TODO: Docstrings
    func image(fromLayer layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContext(layer.frame.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    
    //MARK: - Data Source Methods
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //build the cells
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CourseCell", for: indexPath) as! CourseCell
        super.swipeCellId = RecurringEventCell.id
        printDebug("will try to dequeue cell in CoursesViewController with id: \(self.swipeCellId)")
        if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? RecurringEventCell,
           let course = eventsArray[indexPath.section][indexPath.row] as? Course {
            cell.event = course
            cell.loadData(
                courseName: course.name,
                location: course.location,
                startTime: course.startDate,
                endTime: course.endDate,
                days: course.days,
                color: course.color,
                recurringEvent: course,
                systemIcon: course.logo
            )
            return cell
        }
        
        fatalError("$ERR: Couldn't dequeue cell for Course List")
    }
    
    //MARK: - Delegate Methods
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: SegueIdentifiers.coursesToAssignments.rawValue, sender: self)
    }
    
    //TODO: Docstrings
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AssignmentsOnlyViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCourse = eventsArray[indexPath.section][indexPath.row] as? Course
            }
        }
    }
    
    //MARK: - CRUD Methods
    
    //TODO: Docstrings
    func loadCourses(){
        self.courses = self.databaseService.getStudiumObjects(expecting: Course.self)
        eventsArray = [[],[]]
        for course in courses {
            if course.days.contains(Date().weekdayValue) {
                eventsArray[0].append(course)
            } else {
                eventsArray[1].append(course)
            }
        }

        //sort all the habits happening today by startTime (the ones that are first come first in the list)
        eventsArray[0].sort(by: {$0.startDate.format(with: "HH:mm") < $1.startDate.format(with: "HH:mm")})
        tableView.reloadData()
    }
    
//    func sortCourses() {
//        let stateCourses = StudiumState.state.getCourses()
//        for course in stateCourses {
//            if course.days.contains(Date().week) {
//                eventsArray[0].append(course)
//            } else {
//                eventsArray[1].append(course)
//            }
//        }
//        eventsArray[0].sort(by: { $0.startDate.format(with: "HH:mm") < $1.startDate.format(with: "HH:mm") })
//    }
    
    //TODO: Docstrings
    override func edit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        
        let eventForEdit = deletableEventCell.event! as! Course
        let addCourseViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddCourseViewController") as! AddCourseViewController
        addCourseViewController.delegate = self
        addCourseViewController.course = eventForEdit
//        ColorPickerCell.color = eventForEdit.color
        addCourseViewController.title = "View/Edit Course"
        let navController = UINavigationController(rootViewController: addCourseViewController)
        self.present(navController, animated:true, completion: nil)
    }
    
    //TODO: Docstrings
    override func delete(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DeletableEventCell,
           let course = cell.event as? Course {
            print("$LOG: attempting to delete course \(course.name) at section \(indexPath.section) and row \(indexPath.row)")
            self.databaseService.deleteStudiumObject(course)
            //        RealmCRUD.deleteCourse(course: course)
            eventsArray[indexPath.section].remove(at: indexPath.row)
            updateHeader(section: indexPath.section)
            //        tableView.deleteRows(at: [indexPath], with: .automatic)
            
            //        tableView.headerView(forSection: indexPath.section)?.contentConfiguration = config
        } else {
            print("$ERR: cell event wasn't course or cell wasn't deletable event cell.")
        }
    }
        
    //MARK: - UI Actions
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
//        let addCourseViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddCourseViewController") as! AddCourseViewController
        self.coordinator?.showAddCourseViewController(refreshDelegate: self)
//        let navController = UINavigationController(rootViewController: addCourseViewController)
//        ColorPickerCell.color = .white
//        self.present(navController, animated:true, completion: nil)
    }
}
