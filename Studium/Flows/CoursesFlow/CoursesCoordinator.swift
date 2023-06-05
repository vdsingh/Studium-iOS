//
//  CoursesCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

protocol StudiumEventFormCoordinator: NavigationCoordinator {
    var formNavigationController: UINavigationController? { get }
}

//TODO: Docstrings
class CoursesCoordinator: NSObject, TabItemCoordinator, StudiumEventFormCoordinator, LogoSelectionShowingCoordinator, AlertTimesSelectionShowingCoordinator {
    
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
    
    //TODO: Docstrings
    func start(replaceRoot: Bool) {
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
    func childDidFinish(_ child: Coordinator?) {
        
    }
}
