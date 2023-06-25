//
//  AssignmentViewModel.swift
//  AssignmentsWidgetExtension
//
//  Created by Vikram Singh on 6/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

struct AssignmentViewModel: Identifiable {
    var id: String = UUID().uuidString
    var assignmentName: String
    var isCompleted: Bool = false
}

class AssignmentDataModel {
    static let shared = AssignmentDataModel()
    
    var assignments: [AssignmentViewModel] = [
        .init(assignmentName: "Homework 3"),
        .init(assignmentName: "Project 4"),
        .init(assignmentName: "Exam 3")
    ]
}
