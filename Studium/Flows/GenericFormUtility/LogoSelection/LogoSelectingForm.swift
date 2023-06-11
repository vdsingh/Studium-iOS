//
//  LogoSelectingForm.swift
//  Studium
//
//  Created by Vikram Singh on 6/5/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

/// Forms  in which a logo selection VC is used can use this protocol to gain the showLogoSelectionViewController function. Note: this function delegates showing the correct controller to the Coordinator (which must be a LogoSelectionShowingCoordinator) and sets the update delegate to self.
protocol LogoSelectingForm: Coordinated, MasterForm, ErrorShowing {
    
    //TODO: Docstrings
    func showLogoSelectionViewController()
}

extension LogoSelectingForm {
    
    //TODO: Docstrings
    func showLogoSelectionViewController() {
        self.printDebug("showLogoSelectionViewController called")
        guard let coordinator = self.coordinator else {
            self.showError(.nilCoordinator)
            return
        }
        
        if let coordinator = coordinator as? LogoSelectionShowingCoordinator {
            coordinator.showLogoSelectionViewController(updateDelegate: self)
        } else {
            self.showError(.nonConformingCoordinator)
            Log.s(LogoSelectingFormError.failedToUnwrapAsLogoSelectionShowingCoordinator, additionalDetails: "Tried to show LogoSelection Flow but the coordinator is not LogoSelectionShowingCoordinator. Coordinator: \(String(describing: self.coordinator))")
        }
    }
}

enum LogoSelectingFormError: Error {
    case failedToUnwrapAsLogoSelectionShowingCoordinator
}

