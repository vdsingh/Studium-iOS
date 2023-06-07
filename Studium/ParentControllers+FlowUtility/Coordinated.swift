//
//  Coordinated.swift
//  Studium
//
//  Created by Vikram Singh on 6/6/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Move
protocol Coordinated {
    associatedtype CoordinatorType: Coordinator
    var coordinator: CoordinatorType? { get set }
    
    func unwrapCoordinatorOrShowError()
}

extension Coordinated where Self: ErrorShowing {
    
    // TODO: Docstrings
    func unwrapCoordinatorOrShowError() {
        if self.coordinator == nil {
            self.showError(.nilCoordinator)
            return
        }
    }
}
