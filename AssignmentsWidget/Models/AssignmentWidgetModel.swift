//
//  AssignmentWidgetModel.swift
//  Studium
//
//  Created by Vikram Singh on 6/25/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

struct AssignmentWidgetModel: Codable {
    let id: String
    let name: String
    let dueDate: Date
    let course: String
    var isComplete: Bool
}
