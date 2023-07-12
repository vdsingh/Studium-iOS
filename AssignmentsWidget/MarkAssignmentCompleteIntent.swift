//
//  MarkAssignmentCompleteIntent.swift
//  Studium
//
//  Created by Vikram Singh on 7/6/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct MarkAssignmentCompleteIntent: AppIntent {

    
    
    @Parameter(title: "Assignment ID")
    var assignmentID: String
    
    static var title: LocalizedStringResource = "Complete an Assignment"
    
    static var description = IntentDescription("Change the completeness status of an Assignment.")
    
    init() { }
    
    init(assignmentID: String) {
        self.assignmentID = assignmentID
    }
    
    func perform() async throws -> some IntentResult {
        print("PERFORM CALLED")
        let dataService = AssignmentsWidgetDataService.shared
        guard let assignment = dataService.getAssignment(withID: self.assignmentID) else {
            fatalError()
        }
        
        dataService.markComplete(assignment, complete: !assignment.isComplete)
        return .result()
//        let transactions = try await BudgetManager.shared
//            .prepareExportOfTransactions(after: date, for: merchant)
//            
//        return .result(value: transactions)
    }
}
