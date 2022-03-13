//
//  RealmSave.swift
//  Studium
//
//  Created by Vikram Singh on 5/22/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class RealmCRUD{
    static func saveAssignment(assignment: Assignment, parentCourse: Course){
        print("just about to save")
        guard let user = K.app.currentUser else {
            print("Error getting user when saving Assignment")
            return
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        do{ //adding the assignment to the courses list of assignments
            try realm.write{
                parentCourse.assignments.append(assignment)
            }
            assignment.initiateAutoSchedule()
        }catch{
            print("error appending assignment")
        }
    }
    
//    static func deleteAssignment(assignment: Assignment){
//        guard let user = K.app.currentUser else {
//            print("Error getting user when deleting Assignment")
//            return
//        }
//        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
//        do{
//            try realm.write{
////                    guard let course = assignment.parentCourse else{
////                        print("Error accessing parent course in AssignmentViewController")
////                        return
////                    }
////                    let assignmentIndex = course.assignments.index(of: assignment)
////                    course.assignments.remove(at: assignmentIndex!)
////                    assignment.deleteNotifications()
//                realm.delete(assignment)
//                for autoEvent in assignment.scheduledEvents{
//                    realm.delete(autoEvent)
//                }
//            }
//        }catch{
//            print("error writing to realm when deleting assignment \(assignment.name)")
//        }
//    }
    
    static func deleteAssignment(assignment: Assignment){
        guard let user = K.app.currentUser else {
            print("Error getting user when deleting Assignment")
            return
        }
        do{
            let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
            try realm.write{
                guard let course = assignment.parentCourse else{
                    print("Error accessing parent course in AssignmentViewController")
                    return
                }
                let assignmentIndex = course.assignments.index(of: assignment)
                course.assignments.remove(at: assignmentIndex!)
//                assignment.deleteNotifications()
//                cell.event!.deleteNotifications()
//                realm.delete(cell.event!)
                realm.delete(assignment)
            }
        }catch{
            print("Error deleting OtherEvent")
        }
    }
    
    static func deleteCourse(course: Course){
        guard let user = K.app.currentUser else {
            print("ERROR: error getting user when deleting course")
            return
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        do{
            for assignment in course.assignments{
                deleteAssignment(assignment: assignment)
            }
            try realm.write{
                realm.delete(course)
            }
        }catch{
            print("ERROR: error writing to realm when deleting course \(course.name)")
        }
    }
    
    //saves the new course to the Realm database.
    static func saveCourse(course: Course){
        guard let user = K.app.currentUser else {
            print("ERROR: error getting user when saving course")
            return
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        do{
            try realm.write{
                realm.add(course)
                print("the user id is: \(user.id)")
                print("saved course with partitionKey: \(course._partitionKey)")
            }
        }catch{
            print("error saving course: \(error)")
        }
    }
    
    static func saveHabit(habit: Habit){
        guard let user = K.app.currentUser else {
            print("Error getting user")
            return
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        do{
            try realm.write{
                realm.add(habit)
            }
        }catch{
            print("error saving course: \(error)")
        }
    }
    
    static func saveOtherEvent(otherEvent: OtherEvent){
        guard let user = K.app.currentUser else {
            print("ERROR: error getting user when saving otherEvent")
            return
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        do{
            try realm.write{
                realm.add(otherEvent)
            }
        }catch{
            print("ERROR: error saving course: \(error)")
        }
    }
}
