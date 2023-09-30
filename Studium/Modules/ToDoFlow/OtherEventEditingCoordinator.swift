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
//    func showEditOtherEventViewController(refreshDelegate: ToDoListRefreshProtocol, otherEventToEdit: OtherEvent)
}
 
extension OtherEventEditingCoordinator {
    
    
    /// Shows form to edit/add an OtherEvent
    /// - Parameters:
    ///   - refreshDelegate: Called after form has completed (not called if form is cancelled)
    ///   - otherEventToEdit: Event to edit. If nil, will display add event form
    func showOtherEventFormViewController(refreshDelegate: ToDoListRefreshProtocol, otherEventToEdit: OtherEvent?) {
        let editOtherEventVC = OtherEventFormViewController(otherEventToEdit: otherEventToEdit, refreshCallback: {
            refreshDelegate.reloadData()
        })
        self.navigationController.topViewController?.present(editOtherEventVC, animated: true)
    }
}
