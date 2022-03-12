////
////  AssignmentHolderList.swift
////  Studium
////
////  Created by Vikram Singh on 3/12/22.
////  Copyright © 2022 Vikram Singh. All rights reserved.
////
//
//import Foundation
//import UIKit
//
////this class is meant to hold all of the commonalities between ToDoListViewController and AssignmentsViewController to avoid repeating code. For example, the functions for AssignmentCollapseDelegate will be implemented the same for both, so instead we'll implement them here once and have ToDoListViewController and AssignmentsViewController inherit this.
//class AssignmentHolderList: SwipeTableViewController, AssignmentCollapseDelegate{
//
//    var assignmentsArr: [[Assignment]] = [[],[]]
//
//    func handleOpenAutoEvents(assignment: Assignment) {
//
//        let arrayIndex = assignment.complete ? 1 : 0
//        print("Handle opening auto events")
//
//        if let ind = assignmentsArr[arrayIndex].firstIndex(of: assignment){
//            var index = ind + 1
//            for auto in assignment.scheduledEvents{
//                assignmentsArr[arrayIndex].insert(auto, at: index)
//                index += 1
//            }
//        }else{
//            print("- Error accessing assignment when opening auto list events. \(assignment.name) is not in the assignments array.")
//        }
//
//        tableView.reloadData()
//    }
//
//    func handleCloseAutoEvents(assignment: Assignment) {
//        print("Handle close auto events")
//
//        let arrayIndex = assignment.complete ? 1 : 0
//        let index = assignmentsArr[arrayIndex].firstIndex(of: assignment)!
//
//        for _ in assignment.scheduledEvents{
//            assignmentsArr[arrayIndex].remove(at: index + 1)
//        }
//        tableView.reloadData()
//    }
//}
