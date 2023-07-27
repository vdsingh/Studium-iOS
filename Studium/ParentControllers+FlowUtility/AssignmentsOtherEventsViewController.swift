//
//  AssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/12/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import VikUtilityKit
import UIKit

protocol ForegroundSubscriber {
    func willEnterForeground()
}

//TODO: Docstrings
class AssignmentsOtherEventsViewController: StudiumEventListViewController, ForegroundSubscriber {
    
    override var debug: Bool {
        return true
    }
    
    //TODO: Docstrings
    var assignmentsExpandedSet = Set<Assignment>()
    
    override func viewDidLoad() {
        self.sceneDelegate!.addForegroundSubscriber(self)
        super.viewDidLoad()
    }
    
    func willEnterForeground() {
        print("WILL ENTER FOREGROUND")
        self.reloadData()
    }
        
    //TODO: Docstrings
    func loadEvents() { }
    
    /// Reloads/sorts the data and refreshes the TableView
    func reloadData() { }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        printDebug("Selected row \(indexPath.row)")
        if let assignment = self.eventsArray[indexPath.section][indexPath.row] as? Assignment,
           let assignmentCell = tableView.cellForRow(at: indexPath) as? AssignmentCell1 {
            let vc = AssignmentViewController(assignment: assignment)
            self.present(vc, animated: true)
//            self.handleEventsClose(assignment: assignment)
            
//            self.studiumEventService.markComplete(assignment, !assignment.complete)
//            if assignment.autoscheduled {
//                tableView.reloadData()
//            } else {
//                reloadData()
//            }
//            self.reloadData()
//            tableView.deselectRow(at: indexPath, animated: true)
        } else if let otherEventCell = tableView.cellForRow(at: indexPath) as? OtherEventCell,
           let otherEvent = otherEventCell.event as? OtherEvent {
            print("$LOG: Selected an otherEventCell")
            self.studiumEventService.markComplete(otherEvent, !otherEvent.complete)
//            if otherEvent.autoscheduled {
//                tableView.reloadData()
//            } else {
//                reloadData()
//            }
        }
        
        self.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //TODO: Docstrings, move to AssignmentsOther...
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

        //TODO: Docstrings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let assignment = eventsArray[indexPath.section][indexPath.row] as? Assignment {
            super.swipeCellId = AssignmentCell1.id
            if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? AssignmentCell1 {
                cell.event = assignment
                cell.loadData(
                    assignment: assignment,
                    assignmentCollapseDelegate: self,
                    checkboxWasTappedCallback: {
                        self.studiumEventService.markComplete(assignment, !assignment.complete)
                        self.reloadData()
                    }
                )
                
                cell.setIsExpanded(isExpanded: self.assignmentsExpandedSet.contains(assignment))
                return cell
            }
        } else if let otherEvent = eventsArray[indexPath.section][indexPath.row] as? OtherEvent {
            super.swipeCellId = OtherEventCell.id
            if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? OtherEventCell {
                cell.event = otherEvent
                cell.loadData(from: otherEvent)
                return cell
            }
        }
        
        fatalError("$ERR: Couldn't dequeue cell for Course List")
    }
}

/// Handle what happens when user wants to collapsed autoscheduled events.
extension AssignmentsOtherEventsViewController: AssignmentCollapseDelegate {
    
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
            for auto in assignment.autoscheduledEvents {
                // Add the autoscheduled events to the events array
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
            for _ in assignment.autoscheduledEvents {
                eventsArray[assignmentSection].remove(at: assignmentRow + 1)
            }
        } else {
            Log.s(AssignmentsViewControllerError.failedToFindAssignment, additionalDetails: "problem accessing assignment when closing auto list events. \(assignment.name) is not in the assignments array.")
        }
        
        self.assignmentsExpandedSet.remove(assignment)
        self.tableView.reloadData()
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

enum AssignmentsViewControllerError: Error {
    case failedToFindAssignment
}
