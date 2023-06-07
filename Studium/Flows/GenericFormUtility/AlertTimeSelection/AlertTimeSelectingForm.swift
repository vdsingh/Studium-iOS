//
//  AlertTimeSelectingForm.swift
//  Studium
//
//  Created by Vikram Singh on 6/4/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

/// Forms  in which an Alert time selection VC is used can use this protocol to gain the showAlertTimesSelectionViewController function. Note: this function delegates showing the correct controller to the Coordinator (which must be a AlertTimesSelectionShowingCoordinator) and sets the update delegate to self.
protocol AlertTimeSelectingForm: Coordinated, MasterForm, ErrorShowing {
    
    // TODO: Docstrings
    func showAlertTimesSelectionViewController()
}

extension AlertTimeSelectingForm {
    
    // TODO: Docstrings
    func showAlertTimesSelectionViewController() {
        self.printDebug("showAlertTimesSelectionViewController called")

        guard let coordinator = self.coordinator else {
            self.showError(.nilCoordinator)
            return
        }
        
        if let coordinator = coordinator as? AlertTimesSelectionShowingCoordinator {
            coordinator.showAlertTimesSelectionViewController(updateDelegate: self, selectedAlertOptions: self.alertTimes)
        } else {
            self.showError(.nonConformingCoordinator)
            printError("Tried to show AlertTimesSelection Flow but the coordinator is not AlertTimesSelectionShowingCoordinator. Coordinator: \(String(describing: self.coordinator))")
        }
    }
}
