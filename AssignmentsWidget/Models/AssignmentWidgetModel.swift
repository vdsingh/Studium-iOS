//
//  AssignmentWidgetModel.swift
//  Studium
//
//  Created by Vikram Singh on 6/25/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import AppIntents

class AssignmentWidgetModel: NSObject, Codable {
    let id: String
    let name: String
    let dueDate: Date
    let course: String
    var isComplete: Bool
    let colorHex: String
    
    init(id: String, name: String, dueDate: Date, course: String, isComplete: Bool, colorHex: String) {
        self.id = id
        self.name = name
        self.dueDate = dueDate
        self.course = course
        self.isComplete = isComplete
        self.colorHex = colorHex
    }
}
