//
//  Updatable.swift
//  Studium
//
//  Created by Vikram Singh on 8/17/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

protocol Updatable {
    associatedtype EventType
    
    func updateFields(withNewEvent event: EventType)
}
