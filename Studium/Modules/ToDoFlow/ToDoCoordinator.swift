//
//  ToDoCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Docstrings
class ToDoCoordinator: NSObject, TabItemCoordinator, StudiumEventFormCoordinator, AlertTimesSelectionShowingCoordinator, AssignmentEditingCoordinator, OtherEventEditingCoordinator {

    //TODO: Docstrings
    weak var parentCoordinator: Coordinator?
        
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
    var navigationController: UINavigationController
    
    //TODO: Docstrings
    var formNavigationController: UINavigationController?
    
    //TODO: Docstrings
    var tabItemConfig: TabItemConfig = .toDoFlow
    
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
        self.showToDoListViewController()
    }
    
    //TODO: Docstrings
    func showToDoListViewController() {
        let rootVC = ToDoListViewController.instantiate()
        rootVC.coordinator = self
        rootVC.tabBarItem = UITabBarItem(title: self.tabItemConfig.title, image: self.tabItemConfig.images.unselected, tag: self.tabItemConfig.orderNumber)
        rootVC.tabBarItem.selectedImage = self.tabItemConfig.images.selected
        self.navigationController.pushViewController(rootVC, animated: false)
    }
    
    //TODO: Docstrings
    func showAddToDoListEventViewController(refreshDelegate: ToDoListRefreshProtocol) {
        let addToDoEventVC = AddToDoListEventViewController.instantiate()
        let navController = UINavigationController(rootViewController: addToDoEventVC)
        addToDoEventVC.delegate = refreshDelegate
        addToDoEventVC.coordinator = self
        self.navigationController.topViewController?.present(navController, animated: true)
        self.formNavigationController = navController
    }
    
    func childDidFinish(_ child: Coordinator?) {
        fatalError("ToDoCoordinator should not have any children.")
    }
}
