//
//  AssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/12/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class AssignmentsViewController: StudiumEventListViewController {
    
    override var debug: Bool {
        return true
    }
    
    var assignmentsExpandedSet = Set<Assignment>()
    
    func loadAssignments() { }
    
    /// Reloads/sorts the data and refreshes the TableView
    func reloadData() { }
}

// MARK: - TableView Delegate
extension AssignmentsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printDebug("Selected row \(indexPath.row)")
        if let assignment = eventsArray[indexPath.section][indexPath.row] as? Assignment,
           let assignmentCell = tableView.cellForRow(at: indexPath) as? AssignmentCell1 {
            self.handleEventsClose(assignment: assignment)
            self.databaseService.markComplete(assignment, !assignment.complete)
            
            if(assignment.isAutoscheduled) {
                tableView.reloadData()
            } else {
                reloadData()
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            print("$ERR (AssignmentsViewController): couldn't safely cast assignment or its cell")
        }
    }
}


/// Handle what happens when user wants to collapsed autoscheduled events.
extension AssignmentsViewController: AssignmentCollapseDelegate {
    
    /// The collapse button in a cell was clicked
    /// - Parameter assignment: The assignment associated with the cell
    func collapseButtonClicked(assignment: Assignment) {

        // The assignment is expanded
        if self.assignmentsExpandedSet.contains(assignment) {
            self.handleEventsClose(assignment: assignment)
            self.assignmentsExpandedSet.remove(assignment)
        } else {
            self.handleEventsOpen(assignment: assignment)
            self.assignmentsExpandedSet.insert(assignment)
        }
    }
    
    /// Handles the opening of autoscheduled events for an Assignment
    /// - Parameter assignment: The Assignment for which we want to open autoscheduled events
    func handleEventsOpen(assignment: Assignment) {
        let assignmentSection = assignment.complete ? 1 : 0
        if let assignmentRow = eventsArray[assignmentSection].firstIndex(of: assignment) {
            printDebug("Handling opening auto events for assignment at index (\(assignmentSection), \(assignmentRow))")
            var index = assignmentRow + 1
            for auto in assignment.scheduledEvents {
                eventsArray[assignmentSection].insert(auto, at: index)
                index += 1
            }
        } else {
            print("$ERR (AssignmentsViewController): problem accessing assignment when opening auto list events. \(assignment.name) is not in the assignments array.")
        }
        
        tableView.reloadData()
    }

    /// Handles the closing of autoscheduled events for an Assignment
    /// - Parameter assignment: The Assignment for which we want to close autoscheduled events
    func handleEventsClose(assignment: Assignment) {
        // assignment is not expanded
        if !self.assignmentsExpandedSet.contains(assignment) {
            return
        }
        
        let assignmentSection = assignment.complete ? 1 : 0
        if let assignmentRow = eventsArray[assignmentSection].firstIndex(of: assignment) {
            printDebug("Handling closing auto events for assignment at index (\(assignmentSection), \(assignmentRow))")
            for _ in assignment.scheduledEvents {
                eventsArray[assignmentSection].remove(at: assignmentRow + 1)
            }
        } else {
            print("$ERR (AssignmentsViewController): problem accessing assignment when closing auto list events. \(assignment.name) is not in the assignments array.")
        }
        
        self.assignmentsExpandedSet.remove(assignment)
        tableView.reloadData()
    }
    
    /// collapses all assignmentCells whose autoscheduled events are expanded
    func collapseAllExpandedAssignments(){
        for cell in tableView.visibleCells {
            if let assignmentCell = cell as? AssignmentCell1 {
                guard let assignment = assignmentCell.event as? Assignment else {
                    print("$ERR (AssignmentsViewController): tried to unwrap cell event as assignment but failed. Event: \(String(describing: assignmentCell.event))")
                    continue
                }
                
                self.handleEventsClose(assignment: assignment)
            }
        }
    }
}
