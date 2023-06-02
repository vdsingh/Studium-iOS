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
    
    //TODO: Docstrings
    weak var parentCoordinator: Coordinator?
    
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
//    var navigationController: UINavigationController
    
    //TODO: Docstrings
    var tabBarController: TabBarController
    
    //TODO: Docstrings
    init() {
//        self.navigationController = navigationController
        self.childCoordinators = [
            CalendarCoordinator(UINavigationController()),
            HabitsCoordinator(UINavigationController()),
            CoursesCoordinator(UINavigationController()),
            ToDoCoordinator(UINavigationController())
        ]
        
        self.tabBarController = TabBarController(tabItemCoordinators: self.childCoordinators as! [TabItemCoordinator])
    }
    
    func start() {
        self.showTabBarController(replaceRoot: (false, animated: false))
    }
    
    //TODO: Docstrings
    func start(replaceRoot: (Bool, animated: Bool)) {
        self.printDebug("TabBarCoordinator start called")
        self.showTabBarController(replaceRoot: replaceRoot)
        self.printDebug("TabBarCoordinator start finished")
    }
    
    //TODO: Docstrings
    func showTabBarController(replaceRoot: (Bool, animated: Bool)) {
//        if replaceRoot.0 {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(self.tabBarController)
//        } else {
//            self.navigationController.pushViewController(self.tabBarController, animated: replaceRoot.animated)
//        }
    }
    
    //TODO: Implement
    func childDidFinish(_ child: Coordinator?) {
        return
    }
}
