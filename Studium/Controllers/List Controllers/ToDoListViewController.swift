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
class ToDoListViewController: AssignmentsViewController, ToDoListRefreshProtocol, AssignmentRefreshProtocol {
    
    // TODO: Docstrings
    override var debug: Bool {
        return false
    }
    
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
        self.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.collapseAllExpandedAssignments()
    }
    
    //TODO: Docstrings
    override func reloadData(){
        eventsArray = [[],[]]

        let assignments = self.databaseService.getStudiumObjects(expecting: Assignment.self)
        printDebug("ASSIGNMENTS: \(assignments)")
        let otherEvents = self.databaseService.getStudiumObjects(expecting: OtherEvent.self)
        
        for assignment in assignments {
            if assignment.isAutoscheduled {
                continue
            }
            
            if assignment.complete {
                eventsArray[1].append(assignment)
            } else {
                eventsArray[0].append(assignment)
            }
        }
        
        for otherEvent in otherEvents {
            if otherEvent.complete {
                eventsArray[1].append(otherEvent)
            } else {
                eventsArray[0].append(otherEvent)
            }
        }
        
        eventsArray[0] = eventsArray[0].sorted(by: { $0.startDate.compare($1.startDate) == .orderedAscending })
        eventsArray[1] = eventsArray[1].sorted(by: { $0.startDate.compare($1.startDate) == .orderedDescending })

        tableView.reloadData()
    }
    
    //TODO: Docstrings
    override func edit(at indexPath: IndexPath) {
        let deletableEventCell = tableView.cellForRow(at: indexPath) as! DeletableEventCell
        if let assignment = deletableEventCell.event! as? Assignment,
           let addAssignmentViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddAssignmentViewController") as? AddAssignmentViewController {
            addAssignmentViewController.delegate = self
            addAssignmentViewController.assignmentEditing = assignment
            addAssignmentViewController.title = "View/Edit Assignment"
            let navController = UINavigationController(rootViewController: addAssignmentViewController)
            self.present(navController, animated:true, completion: nil)
        } else if let otherEvent = deletableEventCell.event! as? OtherEvent,
                  let addToDoListEventViewController = self.storyboard!.instantiateViewController(withIdentifier: "AddToDoListEventViewController") as? AddToDoListEventViewController {
            addToDoListEventViewController.delegate = self
            addToDoListEventViewController.otherEvent = otherEvent
            addToDoListEventViewController.title = "View/Edit To-Do Event"
            let navController = UINavigationController(rootViewController: addToDoListEventViewController)
            self.present(navController, animated:true, completion: nil)
        }
    }
    
    //TODO: Docstrings
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let addToDoListEventViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddToDoListEventViewController") as! AddToDoListEventViewController
        addToDoListEventViewController.delegate = self
        let navController = UINavigationController(rootViewController: addToDoListEventViewController)
        self.present(navController, animated:true, completion: nil)
    }
 
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let event = eventsArray[indexPath.section][indexPath.row] as? Assignment {
            super.swipeCellId = AssignmentCell1.id
            if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? AssignmentCell1,
               let assignment = eventsArray[indexPath.section][indexPath.row] as? Assignment {
                cell.loadData(assignment: assignment, assignmentCollapseDelegate: self)
                cell.setIsExpanded(isExpanded: self.assignmentsExpandedSet.contains(assignment))
                return cell
            }
            
            fatalError("$ERR: Couldn't dequeue cell for assignment \(event.name)")
        } else if let event = eventsArray[indexPath.section][indexPath.row] as? OtherEvent {
            super.swipeCellId = OtherEventCell.id
            if let cell = super.tableView(tableView, cellForRowAt: indexPath) as? OtherEventCell,
               let otherEvent = eventsArray[indexPath.section][indexPath.row] as? OtherEvent {
                cell.loadData(from: otherEvent)
                return cell
            }
            
            fatalError("$ERR: Couldn't dequeue cell for other event \(event.name)")

        } else {
            print("$ERR: couldn't unwrap event as Assignment or ToDoEvent")
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            return cell
        }
    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        print("assignmetncell at section \(indexPath.section). row \(indexPath.row)")
        return 60
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
////        let headerCell = tableView.dequeueReusableCell(withIdentifier: K.headerCellID) as! HeaderView
//        let headerView = HeaderView()
//        headerView.setTexts(primaryText: sectionHeaders[section], secondaryText: "\(eventsArray[section].count) Events")
//        headerViews[section] = headerView
//
//        return headerView
//    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // super didSelectRow handles marking events complete (in Realm)
        super.tableView(tableView, didSelectRowAt: indexPath)
        
//        if let assignmentCell = tableView.cellForRow(at: indexPath) as? AssignmentCell1 {
//            if let assignment = assignmentCell.event as? Assignment {
////                if assignmentCell.autoEventsOpen {
////                    assignmentCell.collapseButtonPressed(assignmentCell.chevronButton)
////                }
//                
//                //if the assignment is autoscheduled, we don't want to call loadAssignments() because all autoscheduled events will be removed from the data, and thus the tableView. We'll have index and UI issues.
//                if(assignment.isAutoscheduled) {
//                    tableView.reloadData()
//                } else {
////                    loadAssignments()
//                    reloadData()
//                }
//            }
//        } else
        
        if let cell = tableView.cellForRow(at: indexPath) as? OtherEventCell,
           let otherEvent = cell.otherEvent {
            print("$LOG: Selected an otherEventCell")
            self.databaseService.markComplete(otherEvent, !otherEvent.complete)
            tableView.reloadData()
            reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//TODO: Docstrings
//extension ToDoListViewController: AssignmentCollapseDelegate{
//
//    //TODO: Docstrings
//    func collapseButtonClicked(assignment: Assignment) {
//        // The assignment is expanded
////        if self.assignmentsExpandedSet.contains(assignment) {
////            self.handleCloseAutoEvents(assignment: assignment)
////            self.assignmentsExpandedSet.remove(assignment)
////        } else {
////            self.handleOpenAutoEvents(assignment: assignment)
////            self.assignmentsExpandedSet.insert(assignment)
////        }
//    }
//
//    //TODO: Docstrings
//    func handleOpenAutoEvents(assignment: Assignment) {
//        let arrayIndex = assignment.complete ? 1 : 0
//
//        if let ind = eventsArray[arrayIndex].firstIndex(of: assignment) {
//            var index = ind + 1
//            for auto in assignment.scheduledEvents{
//                eventsArray[arrayIndex].insert(auto, at: index)
//                index += 1
//            }
//        } else {
//            print("$ERR: problem accessing assignment when opening auto list events. \(assignment.name) is not in the assignments array.")
//        }
//
//        tableView.reloadData()
//    }
//
//    //TODO: Docstrings
//    func handleCloseAutoEvents(assignment: Assignment) {
//
//        let arrayIndex = assignment.complete ? 1 : 0
//        let index = eventsArray[arrayIndex].firstIndex(of: assignment)!
//
//        for _ in assignment.scheduledEvents{
//            eventsArray[arrayIndex].remove(at: index + 1)
//        }
//        tableView.reloadData()
//    }
//
//    /// this function collapses all assignmentCells whose autoscheduled events are expanded. We call this when we are leaving the ToDoList screen, to avoid issues when coming back and loading in data.
//    func collapseAllExpandedAssignments(){
//        for cell in tableView.visibleCells{
//            if let assignmentCell = cell as? AssignmentCell1 {
////                if assignmentCell.autoEventsOpen {
////                    assignmentCell.collapseButtonPressed(assignmentCell.chevronButton)
////                }
//            }
//        }
//    }
//}
