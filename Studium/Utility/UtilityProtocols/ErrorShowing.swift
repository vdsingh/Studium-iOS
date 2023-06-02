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
    
    // TODO: Docstrings
    var errorInfo: (title: String, message: String, actions: [UIAlertAction]) {
        switch self {
        case .nilCoordinator:
            return (title: "Whoops!", message: "An error occurred! Please restart the application.", actions: [UIAlertAction(title: "OK", style: .default)])
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
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // TODO: Docstrings
    func showError(_ errorType: ErrorType) {
        let errorInfo = errorType.errorInfo
        showError(title: errorInfo.title, message: errorInfo.message, actions: errorInfo.actions)
    }
}
