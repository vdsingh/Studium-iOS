//
//  AssignmentEditingCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 6/7/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

// TODO: Docstrings
protocol AssignmentEditingCoordinator: CoursesCoordinator {
    
    // TODO: Docstrings
    func showEditAssignmentViewController(refreshDelegate: AssignmentRefreshProtocol, assignmentToEdit: Assignment)
}
 
extension AssignmentEditingCoordinator {
    
    //TODO: Docstrings
    func showEditAssignmentViewController(refreshDelegate: AssignmentRefreshProtocol, assignmentToEdit: Assignment) {
        let addAssignmentVC = AddAssignmentViewController.instantiate()
        let navController = UINavigationController(rootViewController: addAssignmentVC)
        addAssignmentVC.delegate = refreshDelegate
        addAssignmentVC.selectedCourse = assignmentToEdit.parentCourse
        addAssignmentVC.assignmentEditing = assignmentToEdit
        addAssignmentVC.title = "View/Edit Assignment"
        addAssignmentVC.coordinator = self

        self.navigationController.topViewController?.present(navController, animated: true)
        
        self.formNavigationController = navController
    }
}
