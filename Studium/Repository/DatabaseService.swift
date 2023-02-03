//
//  DatabaseHandler.swift
//  Studium
//
//  Created by Vikram Singh on 1/26/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
final class DatabaseService {
    static let shared = DatabaseService()
    
    private init() {}
    
    let app = App(id: Secret.appID)
    
    var user: User? {
        guard let user = app.currentUser else {
            print("$Error: Current User is nil")
            return nil
        }
        
        return user
    }
    
    //TODO: Make private
    var realm: Realm {
        if let user = self.user {
            do {
                return try Realm(configuration: user.configuration(partitionValue: user.id))
            } catch {
                fatalError("$Error: issue accessing Realm.")
            }
        } else {
            do {
                return try Realm()
            } catch {
                fatalError("$Error: issue accessing Realm.")
            }
        }
    }
    
    public func getStudiumObjects <T: StudiumEvent> (expecting type: T.Type) -> [T] {
        return [T](self.realm.objects(type))
    }
    
    
//    static func deleteAssignment(assignment: Assignment){
//        guard let user = K.app.currentUser else {
//            print("Error getting user when deleting Assignment")
//            return
//        }
//
//        do{
//            let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
//            try realm.write{
//                guard let course = assignment.parentCourse else{
//                    print("Error accessing parent course in AssignmentViewController")
//                    return
//                }
//                let assignmentIndex = course.assignments.index(of: assignment)
//                course.assignments.remove(at: assignmentIndex!)
////                assignment.deleteNotifications()
////                cell.event!.deleteNotifications()
////                realm.delete(cell.event!)
//                realm.delete(assignment)
//            }
//        }catch{
//            print("Error deleting OtherEvent")
//        }
//    }
    public func deleteStudiumObject(_ studiumEvent: StudiumEvent) {
        do {
            try self.realm.write {
                // if we're deleting a course, delete all the assignments in the course
                if let course = studiumEvent as? Course {
                    deleteAssignmentsForCourse(course: course)
                }
                
                realm.delete(studiumEvent)
            }
        } catch {
            print("$Error: error deleting studium object.")
        }
    }
    
    public func saveStudiumObject(_ studiumEvent: StudiumEvent) {
        do {
            try self.realm.write {
                self.realm.add(studiumEvent)
            }
        } catch {
            print("$Error: error deleting studium object.")
        }
    }
    
    public func deleteAssignmentsForCourse(course: Course) {
        for assignment in course.assignments {
            deleteStudiumObject(assignment)
        }
    }
    
    public func getAssignments(forCourse course: Course) -> [Assignment]{
        return [Assignment](course.assignments)
    }
}
