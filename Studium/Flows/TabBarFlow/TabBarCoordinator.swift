//
//  TabBarCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/23/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import UIKit
import Foundation

//TODO: Docstrings
class TabBarCoordinator: Coordinator, Debuggable {
    
    var debug: Bool = false
    
    weak var parentCoordinator: Coordinator?
    
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
    var navigationController: UINavigationController
    
    //TODO: Docstrings
    var tabBarController: TabBarController
    
    //TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.childCoordinators = [
            CalendarCoordinator(UINavigationController()),
            HabitsCoordinator(UINavigationController()),
            CoursesCoordinator(UINavigationController()),
            ToDoCoordinator(UINavigationController())
        ]
        
        self.tabBarController = TabBarController()
        self.tabBarController.tabItemCoordinators = self.childCoordinators as! [TabItemCoordinator]
//        self.start()
    }
    
    //TODO: Docstrings
    func start() {
        self.printDebug("TabBarCoordinator start called")
//        let pages: [TabBarPage] = [.calendarFlow, .habitsFlow, .coursesFlow, .toDoFlow]
//            .sorted(by: { $0.pageOrderNumber < $1.pageOrderNumber })
//        self.tabBarController.set
        
        
//        let habitsVC = HabitsViewController.instantiate()
//        self.tabBarController.setViewControllers([habitsVC], animated: true)
        self.navigationController.pushViewController(self.tabBarController, animated: true)
        self.printDebug("TabBarCoordinator start finished")

    }
    
    //TODO: Implement
    func childDidFinish(_ child: Coordinator?) {
        return
    }
}
