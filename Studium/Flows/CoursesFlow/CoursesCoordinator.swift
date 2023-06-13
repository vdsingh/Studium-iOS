//
//  CoursesCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Docstrings
class CoursesCoordinator: NSObject, TabItemCoordinator, StudiumEventFormCoordinator, LogoSelectionShowingCoordinator, AlertTimesSelectionShowingCoordinator, AssignmentEditingCoordinator {
    
    //TODO: Docstrings
    var debug = false
    
    //TODO: Docstrings
    weak var parentCoordinator: Coordinator?
    
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
    var navigationController: UINavigationController
    
    //TODO: Docstrings
    var formNavigationController: UINavigationController?
    
    //TODO: Docstrings
    var tabItemInfo: TabItemInfo = .coursesFlow
    
    //TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // TODO: Docstrings
    required override init() {
        self.navigationController = UINavigationController()
        super.init()
        self.setRootViewController(self.navigationController)
    }
    
    //TODO: Docstrings
    func start() {
        self.showCoursesListViewController()
    }
    
    //TODO: Docstrings
    func showCoursesListViewController() {
        let coursesListVC = CoursesViewController.instantiate()
        coursesListVC.coordinator = self
        self.navigationController.tabBarItem = UITabBarItem(title: self.tabItemInfo.title, image: self.tabItemInfo.images.unselected, tag: self.tabItemInfo.orderNumber)
        self.navigationController.tabBarItem.selectedImage = self.tabItemInfo.images.selected
        self.navigationController.pushViewController(coursesListVC, animated: false)
    }
    
    //TODO: Docstrings
    func showAddCourseViewController(refreshDelegate: CourseRefreshProtocol) {
        let addCourseVC = AddCourseViewController.instantiate()
        let navController = UINavigationController(rootViewController: addCourseVC)
        addCourseVC.delegate = refreshDelegate
        addCourseVC.coordinator = self
        self.navigationController.topViewController?.present(navController, animated: true)
        self.formNavigationController = navController
    }
    
    //TODO: Docstrings
    func showEditCourseViewController(refreshDelegate: CourseRefreshProtocol, courseToEdit: Course) {
        let addCourseVC = AddCourseViewController.instantiate()
        let navController = UINavigationController(rootViewController: addCourseVC)
        addCourseVC.delegate = refreshDelegate
        addCourseVC.course = courseToEdit
        addCourseVC.title = "View/Edit Course"
        addCourseVC.coordinator = self
        self.navigationController.topViewController?.present(navController, animated: true)
        self.formNavigationController = navController
    }
    
    func showAddAssignmentViewController(refreshDelegate: AssignmentRefreshProtocol, selectedCourse: Course) {
        let addAssignmentVC = AddAssignmentViewController.instantiate()
        let navController = UINavigationController(rootViewController: addAssignmentVC)
        addAssignmentVC.refreshDelegate = refreshDelegate
        addAssignmentVC.coordinator = self
        addAssignmentVC.selectedCourse = selectedCourse
        self.navigationController.topViewController?.present(navController, animated: true)
        self.formNavigationController = navController
    }
    
    func showAssignmentsListViewController(selectedCourse: Course) {
        let assignmentsListVC = AssignmentsOnlyViewController.instantiate()
        assignmentsListVC.coordinator = self
        assignmentsListVC.selectedCourse = selectedCourse
        self.navigationController.pushViewController(assignmentsListVC, animated: true)
    }
    
    //TODO: Docstrings
    func childDidFinish(_ child: Coordinator?) {
        
    }
}
