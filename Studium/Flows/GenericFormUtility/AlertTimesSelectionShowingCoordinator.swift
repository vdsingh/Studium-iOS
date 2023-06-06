//
//  AlertTimesSelectionShowingCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 6/4/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

//TODO: Docstrings
protocol AlertTimesSelectionShowingCoordinator: StudiumEventFormCoordinator {
    
    // TODO: Docstrings
    func showAlertTimesSelectionViewController(updateDelegate: AlertTimeHandler, selectedAlertOptions: [AlertOption])
}


//TODO: Docstrings
extension AlertTimesSelectionShowingCoordinator {
    
    //TODO: Docstrings
    func showAlertTimesSelectionViewController(updateDelegate: AlertTimeHandler, selectedAlertOptions: [AlertOption]) {
        let alertTimesSelectionVC = AlertTimeSelectionForm.instantiate()
        alertTimesSelectionVC.delegate = updateDelegate
        alertTimesSelectionVC.setSelectedAlertOptions(alertOptions: selectedAlertOptions)

        self.formNavigationController?.pushViewController(alertTimesSelectionVC, animated: true)
    }
}
