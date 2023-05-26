//
//  ToDoCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import VikUtilityKit

//TODO: Docstrings
class ToDoCoordinator: TabItemCoordinator {
    
    weak var parentCoordinator: Coordinator?
    
    //TODO: Docstrings
    var tabBarItem = UITabBarItem(title: "ToDo", image: SystemIcon.airplane.createImage(), tag: 0)
    
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
    var navigationController: UINavigationController
    
    //TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //TODO: Docstrings
    func start() {
        let rootVC = ToDoListViewController()
        rootVC.coordinator = self
        self.navigationController.pushViewController(rootVC, animated: false)
    }
}
