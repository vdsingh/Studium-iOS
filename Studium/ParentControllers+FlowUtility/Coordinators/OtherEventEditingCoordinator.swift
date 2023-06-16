//
//  OtherEventEditingCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 6/14/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

// TODO: Docstrings
protocol OtherEventEditingCoordinator: AlertTimesSelectionShowingCoordinator {
    
    // TODO: Docstrings
    func showEditOtherEventViewController(refreshDelegate: ToDoListRefreshProtocol, otherEventToEdit: OtherEvent)
}
 
extension OtherEventEditingCoordinator {
    
    //TODO: Docstrings
    func showEditOtherEventViewController(refreshDelegate: ToDoListRefreshProtocol, otherEventToEdit: OtherEvent) {
        let addToDoEventVC = AddToDoListEventViewController.instantiate()
        let navController = UINavigationController(rootViewController: addToDoEventVC)
        addToDoEventVC.delegate = refreshDelegate
        addToDoEventVC.otherEvent = otherEventToEdit
        addToDoEventVC.title = "View/Edit To-Do Event"
        addToDoEventVC.coordinator = self
        self.navigationController.topViewController?.present(navController, animated: true)
        self.formNavigationController = navController
    }
}
