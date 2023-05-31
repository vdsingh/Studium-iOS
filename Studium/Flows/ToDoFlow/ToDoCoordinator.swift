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
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
    var navigationController: UINavigationController
    
    var tabItemInfo: TabItemInfo = .toDoFlow
    
    //TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //TODO: Docstrings
    func start() {
        let rootVC = ToDoListViewController.instantiate()
        rootVC.coordinator = self
        rootVC.tabBarItem = UITabBarItem(title: self.tabItemInfo.title, image: self.tabItemInfo.image, tag: self.tabItemInfo.orderNumber)
        self.navigationController.pushViewController(rootVC, animated: false)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        fatalError("ToDoCoordinator should not have any children.")
    }
}
