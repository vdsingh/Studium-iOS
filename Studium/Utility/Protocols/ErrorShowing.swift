//
//  ErrorShowingController.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

// TODO: Docstrings
enum ErrorType {
    case nilCoordinator
    case nonConformingCoordinator
    case failedCast(objectString: String, intendedTypeString: String)
    
    var defaultErrorInfo: (title: String, message: String, actions: [UIAlertAction]) {
        return (title: "Whoops!", message: "An error occurred! Please restart the application.", actions: [UIAlertAction(title: "OK", style: .default)])
    }
    
    // TODO: Docstrings
    var errorInfo: (title: String, message: String, actions: [UIAlertAction]) {
        switch self {
        case .nilCoordinator:
            return DebugFlags.developerMode == true ?
            (title: "Coordinator is Nil", message: "The coordinator for this screen is nil", actions: [UIAlertAction(title: "OK", style: .default)])
            : self.defaultErrorInfo
            
        case .nonConformingCoordinator:
            return DebugFlags.developerMode == true ?
            (title: "Coordinator does not conform to the intended protocol", message: "Tried to unwrap the coordinator as a specific type, but it did not conform", actions: [UIAlertAction(title: "OK", style: .default)])
            : self.defaultErrorInfo
            
        case .failedCast(let objectString, let intendedTypeString):
            return DebugFlags.developerMode == true ?
            (title: "Failed to cast an Object", message: "Tried to cast the object: \(objectString) as type \(intendedTypeString), but failed", actions: [UIAlertAction(title: "OK", style: .default)])
            : self.defaultErrorInfo
        }
    }
}

// TODO: Docstrings
protocol ErrorShowing {
    
    // TODO: Docstrings
    func showError(title: String, message: String, actions: [UIAlertAction])
    
    // TODO: Docstrings
    func showError(_ errorType: ErrorType)
}

// TODO: Docstrings
extension ErrorShowing where Self: UIViewController {
    
    // TODO: Docstrings
    func showError(
        title: String = "An error occurred",
        message: String = "Please restart the application.",
        actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]
    ) {
        PopUpService.presentToast(title: title, description: message, popUpType: .failure)
    }
    
    // TODO: Docstrings
    func showError(_ errorType: ErrorType) {
        let errorInfo = errorType.errorInfo
        showError(title: errorInfo.title, message: errorInfo.message, actions: errorInfo.actions)
    }
}
