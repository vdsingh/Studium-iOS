//
//  StudiumForm.swift
//  Studium
//
//  Created by Vikram Singh on 6/4/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

// TODO: Docstrings
protocol StudiumForm: Coordinated, MasterForm, ErrorShowing {
    
    // TODO: Docstrings
    func showAlertTimesSelectionViewController()
}

extension StudiumForm {
    
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
