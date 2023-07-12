//
//  DataService.swift
//  AssignmentsWidgetExtension
//
//  Created by Vikram Singh on 6/25/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

class AssignmentsWidgetDataService {
    static let shared = AssignmentsWidgetDataService()
    
    private init() { }
    
    @AppStorage (
        WidgetConstants.nextAssignmentsKey,
        store: UserDefaults(suiteName: WidgetConstants.appGroupSuiteName)
    ) private var nextAssignments = [AssignmentWidgetModel]()
    
    func markComplete(_ assignment: AssignmentWidgetModel, complete: Bool) {
        assignment.isComplete = complete
        self.updateAssignment(updatedAssignment: assignment)
    }
    
    func getAssignments() -> [AssignmentWidgetModel] {
        return self.nextAssignments
    }
    
    func getAssignment(withID id: String) -> AssignmentWidgetModel? {
        return self.getAssignments().first(where: { $0.id == id  })
    }
    
    func setAssignments(_ assignments: [AssignmentWidgetModel]) {
        self.nextAssignments = assignments
    }
    
    func updateAssignment(updatedAssignment: AssignmentWidgetModel) {
        self.nextAssignments.removeAll(where: { $0.id == updatedAssignment.id })
        self.nextAssignments.append(updatedAssignment)
    }
}
