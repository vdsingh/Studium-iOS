//
//  Coordinated.swift
//  Studium
//
//  Created by Vikram Singh on 6/6/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Docstrings
protocol Coordinated {
    
    //TODO: Docstrings
    associatedtype CoordinatorType: Coordinator
    
    //TODO: Docstrings
    var coordinator: CoordinatorType? { get }
    
    //TODO: Docstrings
    func unwrapCoordinatorOrShowError()
}

extension Coordinated where Self: ErrorShowing {
    
    // TODO: Docstrings
    func unwrapCoordinatorOrShowError() {
        if self.coordinator == nil {
            Log.e(ErrorType.nilCoordinator, additionalDetails: "self: \(self)")
            self.showError(.nilCoordinator)
            return
        }
    }
}

