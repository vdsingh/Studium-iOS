//
//  AlertTimesSelectionShowingCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 6/4/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

/// Coordinators that control a flow in which an alert time selection VC is used can use this protocol to gain the showAlertTimesSelectionViewController function
protocol AlertTimesSelectionShowingCoordinator: StudiumEventFormCoordinator {
    
    // TODO: Docstrings
    func showAlertTimesSelectionViewController(updateDelegate: AlertTimeHandler, selectedAlertOptions: [AlertOption])
}


//TODO: Docstrings
extension AlertTimesSelectionShowingCoordinator {
    
    //TODO: Docstrings
    func showAlertTimesSelectionViewController(updateDelegate: AlertTimeHandler, selectedAlertOptions: [AlertOption]) {
        let alertTimesSelectionVC = AlertTimeSelectionTableViewForm.instantiate()
        alertTimesSelectionVC.delegate = updateDelegate
        alertTimesSelectionVC.setSelectedAlertOptions(alertOptions: selectedAlertOptions)

        self.formNavigationController?.pushViewController(alertTimesSelectionVC, animated: true)
    }
}
