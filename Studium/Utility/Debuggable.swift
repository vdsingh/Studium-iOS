//
//  Debuggable.swift
//  Studium
//
//  Created by Vikram Singh on 4/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation


/// Used to debug objects
protocol Debuggable {
    
    /// Whether we are debugging the object
    var debug: Bool { get }
    
    /// Function used to print the debug log
    /// - Parameter message: The message to print
    func printDebug(_ message: String)
}
