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
class ToDoCoordinator: NSObject, TabItemCoordinator, StudiumEventFormCoordinator, AlertTimesSelectionShowingCoordinator, AssignmentEditingCoordinator {
    
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
    var tabItemInfo: TabItemInfo = .toDoFlow
    
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
        rootVC.tabBarItem = UITabBarItem(title: self.tabItemInfo.title, image: self.tabItemInfo.images.unselected, tag: self.tabItemInfo.orderNumber)
        rootVC.tabBarItem.selectedImage = self.tabItemInfo.images.selected
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
    
    //TODO: Docstrings
    func showEditToDoListEventViewController(refreshDelegate: ToDoListRefreshProtocol, toDoEventToEdit: OtherEvent) {
        let addToDoEventVC = AddToDoListEventViewController.instantiate()
        let navController = UINavigationController(rootViewController: addToDoEventVC)
        addToDoEventVC.delegate = refreshDelegate
        addToDoEventVC.otherEvent = toDoEventToEdit
        addToDoEventVC.title = "View/Edit To-Do Event"
        addToDoEventVC.coordinator = self
        self.navigationController.topViewController?.present(navController, animated: true)
        self.formNavigationController = navController
    }
    
    func childDidFinish(_ child: Coordinator?) {
        fatalError("ToDoCoordinator should not have any children.")
    }
}
