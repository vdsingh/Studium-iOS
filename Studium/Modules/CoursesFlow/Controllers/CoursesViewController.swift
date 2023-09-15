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
class CoursesViewController: StudiumEventListViewController, CourseRefreshProtocol, Storyboarded, Coordinated {
    
    // TODO: Docstrings
    weak var coordinator: CoursesCoordinator?
    
    //TODO: Docstrings
    var courses = [Course]()
    
    override func loadView() {
        super.loadView()
        self.emptyDetailIndicatorViewModel = ImageDetailViewModel(image: FlatImage.girlSittingOnBooks.uiImage, title: "No Courses here yet", subtitle: nil, buttonText: "Add a Course", buttonAction: self.addButtonPressed)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Courses"
        self.eventTypeString = "Courses"
        self.sectionHeaders = ["Today:", "Not Today:"]

        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.delegate = self //setting delegate class for the table view to be this
        self.tableView.dataSource = self //setting data source for the table view to be this
        self.tableView.rowHeight = 140
        self.tableView.separatorStyle = .none //gets rid of dividers between cells.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.loadCourses()
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
        // build the cells
        super.swipeCellId = RecurringEventCell.id
        Log.d("will try to dequeue cell in CoursesViewController with id: \(self.swipeCellId)")
        
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
                icon: course.icon
            )
            return cell
        }

        fatalError("$ERR: Couldn't dequeue cell for Course List")
    }
    
    //MARK: - Delegate Methods
    
    //TODO: Docstrings
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let course = self.eventsArray[indexPath.section][indexPath.row] as? Course else {
            self.showError(.failedCast(objectString: "\(self.eventsArray[indexPath.section][indexPath.row])", intendedTypeString: "Course"))
            return
        }
        
        self.coordinator?.showAssignmentsListViewController(selectedCourse: course)
    }
    
    //MARK: - CRUD Methods
    
    //TODO: Docstrings
    func loadCourses() {
        self.courses = self.databaseService.getStudiumObjects(expecting: Course.self)
        eventsArray = [[],[]]
        for course in self.courses {
            if course.days.contains(Date().weekdayValue) {
                eventsArray[0].append(course)
            } else {
                eventsArray[1].append(course)
            }
        }

        // sort all the habits happening today by startTime (the ones that are first come first in the list)
        self.eventsArray[0].sort(by: {$0.startDate.format(with: "HH:mm") < $1.startDate.format(with: "HH:mm")})
        self.tableView.reloadData()
        
        self.updateEmptyEventsIndicator()
    }

    //TODO: Docstrings
    override func edit(at indexPath: IndexPath) {
        if let deletableEventCell = self.tableView.cellForRow(at: indexPath) as? DeletableEventCell,
           let eventForEdit = deletableEventCell.event as? Course {
            self.unwrapCoordinatorOrShowError()
            self.coordinator?.showEditCourseViewController(refreshDelegate: self, courseToEdit: eventForEdit)
        } else {
            Log.e("Couldn't unwrap event as Course")
            PopUpService.shared.presentGenericError()
        }
    }
    
    //TODO: Docstrings
    override func delete(at indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? DeletableEventCell,
           let course = cell.event as? Course {
            Log.d("attempting to delete course \(course.name) at section \(indexPath.section) and row \(indexPath.row)")
            self.studiumEventService.deleteStudiumEvent(course)
            eventsArray[indexPath.section].remove(at: indexPath.row)
            updateHeader(section: indexPath.section)
            self.updateEmptyEventsIndicator()
        } else {
            Log.e("cell event wasn't course or cell wasn't deletable event cell.")
        }
    }
        
    //MARK: - UI Actions
    
    /// Function called when user clicks the "+" button
    override func addButtonPressed() {
        self.coordinator?.showAddCourseViewController(refreshDelegate: self)
    }
}
