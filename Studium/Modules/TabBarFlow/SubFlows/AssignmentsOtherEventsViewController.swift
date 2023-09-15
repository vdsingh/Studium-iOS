//
//  AssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/12/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Docstrings
class AssignmentsOtherEventsViewController: StudiumEventListViewController, AssignmentRefreshProtocol, ForegroundSubscriber {
    
    //TODO: Docstrings
    var assignmentsExpandedIDSet = Set<String>()
    
    override func viewDidLoad() {
        if let sceneDelegate = self.sceneDelegate {
            sceneDelegate.addForegroundSubscriber(self)
        }
        
        super.viewDidLoad()
    }
    
    func willEnterForeground() {
        self.reloadData()
    }
    
    // TODO: Docstrings
    func loadEvents() { }
    
    /// Reloads/sorts the data and refreshes the TableView
    func reloadData() { }
    
    func editAssignment(_ assignment: Assignment) {
        Log.e("editAssignment called from superclass when it should be implemented in subclass.")
        PopUpService.shared.presentGenericError()
    }
    
    func editOtherEvent(_ otherEvent: OtherEvent) {
        Log.e("editOtherEvent called from superclass when it should be implemented in subclass.")
        PopUpService.shared.presentGenericError()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Log.d("Selected row \(indexPath.row)")
        if let assignment = self.displayedEvents[indexPath.section][indexPath.row] as? Assignment,
           let assignmentCell = tableView.cellForRow(at: indexPath) as? AssignmentTableViewCell {
            
            let vc = AssignmentViewController(
                assignment: assignment,
                editButtonPressed: {
                    self.editAssignment(assignment)
                },
                deleteButtonPressed: {
                    PopUpService.shared.presentDeleteAlert {
                        self.navigationController?.popViewController(animated: true)
                        self.studiumEventService.deleteStudiumEvent(assignment)
                        self.reloadData()
                    }
                }
            )
            
            self.navigationController?.modalPresentationStyle = .formSheet
            self.navigationController?.pushViewController(vc, animated: true)
        } else if let otherEventCell = tableView.cellForRow(at: indexPath) as? OtherEventTableViewCell,
                  let otherEvent = otherEventCell.event as? OtherEvent {
            Log.d("Selected an otherEventCell")
            let vc = OtherEventViewController(
                otherEvent: otherEvent,
                editButtonPressed: {
                    self.editOtherEvent(otherEvent)
                },
                deleteButtonPressed: {
                    PopUpService.shared.presentDeleteAlert {
                        self.navigationController?.popViewController(animated: true)
                        self.studiumEventService.deleteStudiumEvent(otherEvent)
                        self.reloadData()
                    }
                }
            )
            
            self.navigationController?.modalPresentationStyle = .formSheet
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let assignment = self.displayedEvents[indexPath.section][indexPath.row] as? Assignment {
            super.swipeCellId = AssignmentTableViewCell.id
            let cell = AssignmentTableViewCell(
                assignment: assignment,
                isExpanded: self.assignmentsExpandedIDSet.contains(assignment._id.stringValue),
                assignmentCollapseHandler: self,
                checkboxWasTapped: {
                    self.studiumEventService.markComplete(assignment, !assignment.complete)
                    self.reloadData()
                }
            )
            
            cell.delegate = self
            cell.setLoading(assignment.isGeneratingEvents)
            return cell
        } else if let otherEvent = self.displayedEvents[indexPath.section][indexPath.row] as? OtherEvent {
            super.swipeCellId = OtherEventTableViewCell.id
            let cell = OtherEventTableViewCell(
                otherEvent: otherEvent,
                checkboxWasTapped: {
                    if let otherEvent = otherEvent.thaw() {
                        self.studiumEventService.markComplete(otherEvent, !otherEvent.complete)
                    }
                    
                    self.reloadData()
                }
            )
            
            cell.delegate = self
            return cell
        }
        
        Log.s(AssignmentsViewControllerError.couldntDequeueCell, additionalDetails: "Issue dequeueing cell. Couldn't dequeue as AssignmentCell or OtherEventCell")
        return UITableViewCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        self.displayedEvents.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.displayedEvents[section].count
    }
    
    // FIXME: Find a better way to handle this (generics)
    override func delete(at indexPath: IndexPath) {
        if let cell = self.tableView.cellForRow(at: indexPath) as? DeletableEventCell,
           let event = cell.event {
            let eventID = event._id
            if let assignment = event as? Assignment {
                DispatchQueue.global(qos: .userInitiated).async {
                    if let event = self.databaseService.getStudiumEvent(withID: eventID, type: Assignment.self) {
                        self.studiumEventService.deleteStudiumEvent(event)
                    } else {
                        Log.e("Failed to retrieve studiumEvent by ID to delete it.", additionalDetails: "Event type: Assignment")
                        PopUpService.shared.presentGenericError()
                    }
                }
            } else if let otherEvent = event as? OtherEvent {
                DispatchQueue.global(qos: .userInitiated).async {
                    if let event = self.databaseService.getStudiumEvent(withID: eventID, type: OtherEvent.self) {
                        self.studiumEventService.deleteStudiumEvent(event)
                    } else {
                        Log.e("Failed to retrieve studiumEvent by ID to delete it.", additionalDetails: "Event type: OtherEvent")
                        PopUpService.shared.presentGenericError()
                    }
                }
            }
            
            self.displayedEvents[indexPath.section].remove(at: indexPath.row)
            self.updateHeader(section: indexPath.section)
            self.updateEmptyEventsIndicator()
        }
    }
}

/// Handle what happens when user wants to collapsed autoscheduled events.
extension AssignmentsOtherEventsViewController: AssignmentCollapseDelegate {
    
    /// The collapse button in a cell was clicked
    /// - Parameter assignment: The assignment associated with the cell
    func collapseButtonClicked(assignment: Assignment) {
        
        // The assignment is expanded
        if self.assignmentsExpandedIDSet.contains(assignment._id.stringValue) {
            self.handleEventsClose(assignment: assignment)
            self.assignmentsExpandedIDSet.remove(assignment._id.stringValue)
        } else {
            self.handleEventsOpen(assignment: assignment)
            self.assignmentsExpandedIDSet.insert(assignment._id.stringValue)
        }
    }
    
    /// Handles the opening of autoscheduled events for an Assignment
    /// - Parameter assignment: The Assignment for which we want to open autoscheduled events
    func handleEventsOpen(assignment: Assignment) {
        let assignmentSection = assignment.complete ? 1 : 0
        if let assignmentRow = self.displayedEvents[assignmentSection].firstIndex(where: { $0._id == assignment._id }) {
            Log.d("Handling opening auto events for assignment at index (\(assignmentSection), \(assignmentRow))")
            var index = assignmentRow + 1
            for auto in assignment.autoscheduledEvents {
                // Add the autoscheduled events to the events array
                self.displayedEvents[assignmentSection].insert(auto, at: index)
                index += 1
            }
        } else {
            Log.e("problem accessing assignment when opening auto list events. \(assignment.name) is not in the assignments array.")
        }
        
        self.tableView.reloadData()
    }
    
    /// Handles the closing of autoscheduled events for an Assignment
    /// - Parameter assignment: The Assignment for which we want to close autoscheduled events
    func handleEventsClose(assignment: Assignment) {
        
        // assignment is not expanded
        if !self.assignmentsExpandedIDSet.contains(assignment._id.stringValue) {
            return
        }
        let expandedEventIDs = assignment.autoscheduledEvents.compactMap({ $0._id })
        let assignmentSection = assignment.complete ? 1 : 0
        self.displayedEvents[assignmentSection].removeAll(where: { expandedEventIDs.contains($0._id) })
        
        self.assignmentsExpandedIDSet.remove(assignment._id.stringValue)
        self.tableView.reloadData()
    }
    
    /// collapses all assignmentCells whose autoscheduled events are expanded
    func collapseAllExpandedAssignments() {
        for cell in self.tableView.visibleCells {
            if let assignmentCell = cell as? AssignmentTableViewCell {
                guard let assignment = assignmentCell.event as? Assignment else {
                    Log.e("tried to unwrap cell event as assignment but failed. Event: \(String(describing: assignmentCell.event))")
                    continue
                }
                
                self.handleEventsClose(assignment: assignment)
            }
        }
    }
}

enum AssignmentsViewControllerError: Error {
    case failedToFindAssignment
    case couldntDequeueCell
    case outOfBounds
}
