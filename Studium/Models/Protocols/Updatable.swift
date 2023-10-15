//
//  Updatable.swift
//  Studium
//
//  Created by Vikram Singh on 8/17/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

// TODO: Docstrings
protocol Updatable {
    associatedtype EventType

    // TODO: Docstrings
    func updateFields(withNewEvent event: EventType)
}
