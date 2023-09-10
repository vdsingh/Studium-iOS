//
//  AllAssignmentsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

//TODO: Docstrings
class ToDoListViewController: AssignmentsOtherEventsViewController, ToDoListRefreshProtocol, AssignmentRefreshProtocol, Coordinated, Storyboarded {
    
    weak var coordinator: ToDoCoordinator?
    
    //TODO: Docstrings
    let assignments = [Assignment]()
    
    //TODO: Docstrings
    let otherEvents = [OtherEvent]()

    override func viewDidLoad() {
        self.eventTypeString = "Events"
        super.viewDidLoad()
                
        sectionHeaders = ["To Do:", "Completed:"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.collapseAllExpandedAssignments()
    }
    
    override func loadEvents() {
        self.eventsArray = [[],[]]

        let assignments = self.databaseService.getStudiumObjects(expecting: Assignment.self)
        let otherEvents = self.databaseService.getStudiumObjects(expecting: OtherEvent.self)
        
        for assignment in assignments {
            if assignment.complete {
                eventsArray[1].append(assignment)
            } else {
                eventsArray[0].append(assignment)
            }
        }
        
        for otherEvent in otherEvents {
            if otherEvent.autoscheduled {
                continue
            }
            
            if otherEvent.complete {
                eventsArray[1].append(otherEvent)
            } else {
                eventsArray[0].append(otherEvent)
            }
        }
        
        eventsArray[0] = eventsArray[0].sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        eventsArray[1] = eventsArray[1].sorted(by: { $0.startDate.compare($1.startDate) == .orderedDescending })

    }
    
    //TODO: Docstrings
    override func reloadData() {
        self.loadEvents()
        tableView.reloadData()
    }
    
    //TODO: Docstrings
    override func edit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        self.unwrapCoordinatorOrShowError()

        if let assignment = deletableEventCell.event! as? Assignment {
            self.coordinator?.showEditAssignmentViewController(refreshDelegate: self, assignmentToEdit: assignment)
        } else if let otherEvent = deletableEventCell.event! as? OtherEvent {
            self.coordinator?.showEditOtherEventViewController(refreshDelegate: self, otherEventToEdit: otherEvent)
        }
    }
    
    //TODO: Docstrings
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        self.unwrapCoordinatorOrShowError()
        self.coordinator?.showAddToDoListEventViewController(refreshDelegate: self)
    }
 
    //TODO: Docstrings
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        if let event = eventsArray[indexPath.section][indexPath.row] as? Assignment {
//            super.swipeCellId = AssignmentCell1.id
//            if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? AssignmentCell1,
//               let assignment = eventsArray[indexPath.section][indexPath.row] as? Assignment {
//                cell.loadData(assignment: assignment, assignmentCollapseDelegate: self)
//                cell.setIsExpanded(isExpanded: self.assignmentsExpandedSet.contains(assignment))
//                return cell
//            }
//            
//            fatalError("$ERR: Couldn't dequeue cell for assignment \(event.name)")
//        } else if let event = eventsArray[indexPath.section][indexPath.row] as? OtherEvent {
//            super.swipeCellId = OtherEventCell.id
//            if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? OtherEventCell,
//               let otherEvent = eventsArray[indexPath.section][indexPath.row] as? OtherEvent {
//                cell.loadData(from: otherEvent)
//                return cell
//            }
//            
//            fatalError("$ERR: Couldn't dequeue cell for other event \(event.name)")
//
//        } else {
//            print("$ERR: couldn't unwrap event as Assignment or ToDoEvent")
//            let cell = super.tableView(tableView, cellForRowAt: indexPath)
//            return cell
//        }
//    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        let headerCell = tableView.dequeueReusableCell(withIdentifier: K.headerCellID) as! HeaderView
//        let headerView = HeaderView()
//        headerView.setTexts(primaryText: sectionHeaders[section], secondaryText: "\(eventsArray[section].count) Events")
//        headerViews[section] = headerView
//
//        return headerView
//    }
    
    //TODO: Docstrings
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        // super didSelectRow handles marking events complete (in Realm)
//        super.tableView(tableView, didSelectRowAt: indexPath)
//        
//        if let cell = tableView.cellForRow(at: indexPath) as? OtherEventCell,
//           let otherEvent = cell.event as? OtherEvent {
//            print("$LOG: Selected an otherEventCell")
//            self.databaseService.markComplete(otherEvent, !otherEvent.complete)
//            tableView.reloadData()
//            reloadData()
//        }
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
}
