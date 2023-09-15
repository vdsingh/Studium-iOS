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
class TabBarCoordinator: NSObject, Coordinator {
        
    //TODO: Docstrings
    weak var parentCoordinator: Coordinator?
    
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()

    //TODO: Docstrings
    var tabBarController: TabBarController
    
    //TODO: Docstrings
    override init() {
        self.childCoordinators = [
            // TODO: Tree coordinator
//            TreeCoordinator(UINavigationController()),
            CalendarCoordinator(UINavigationController()),
            HabitsCoordinator(UINavigationController()),
            CoursesCoordinator(UINavigationController()),
            ToDoCoordinator(UINavigationController())
        ]
        
        self.tabBarController = TabBarController(tabItemCoordinators: self.childCoordinators as! [TabItemCoordinator])
    }
    
    func start() {
        self.showTabBarController(replaceRoot: (true, animated: false))
    }
    
    //TODO: Docstrings
    func start(replaceRoot: (Bool, animated: Bool)) {
        self.showTabBarController(replaceRoot: replaceRoot)
    }
    
    //TODO: Docstrings
    func showTabBarController(replaceRoot: (Bool, animated: Bool)) {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(self.tabBarController)
    }
    
    //TODO: Implement
    func childDidFinish(_ child: Coordinator?) {
        return
    }
}
