//
//  DatabaseHandler.swift
//  Studium
//
//  Created by Vikram Singh on 1/26/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

protocol Debuggable {
    var debug: Bool { get }
    func printDebug(_ message: String)
}

final class DatabaseService {
    let debug = true
    
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
    lazy var realm: Realm = {
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
    }()
    
    //MARK: - Create
    public func saveStudiumObject(_ studiumEvent: StudiumEvent) {
        if studiumEvent is Assignment {
            print("$Error: attempted to save assignment through saveStudiumObject function. Use saveAssignment instead")
            return
        }
        
        printDebug("saving event \(studiumEvent)")
        do {
            try self.realm.write {
                self.realm.add(studiumEvent)
            }
        } catch {
            print("$Error: error deleting studium object.")
        }
    }
    
    public func saveAssignment(assignment: Assignment, parentCourse: Course){
        printDebug("Saving assignment: \(assignment)")
        do {
            try self.realm.write {
                parentCourse.appendAssignment(assignment)
            }
            //TODO: Autoschedule assignments
//            assignment.initiateAutoSchedule()
        } catch {
            print("error appending assignment")
        }
    }
    
    // MARK: - Read
    
    public func getStudiumObjects <T: StudiumEvent> (expecting type: T.Type) -> [T] {
        return [T](self.realm.objects(type))
    }
    
    public func getAssignments(forCourse course: Course) -> [Assignment] {
        return [Assignment](course.assignments)
    }
    
    // MARK: - Update
    
    public func markComplete(_ completableEvent: CompletableStudiumEvent, _ complete: Bool) {
        do {
            try realm.write{
                completableEvent.complete = !completableEvent.complete
            }
        } catch {
            print("$Error: marking complete: \(error)")
        }
    }
    
    public func editStudiumEvent(oldEvent: StudiumEvent, newEvent: StudiumEvent) {
        printDebug("editing StudiumEvent")
//        if(oldEvent._id != newEvent._id) {
//            print("$ERR (DatabaseService): tried to update an event but the id did not match. Old Event: \(oldEvent._id) != \(newEvent._id)")
//            return
//        }
        
        newEvent.setID(oldEvent._id)
        
        do {
            try self.realm.write{
                realm.add(newEvent, update: .modified)
            }
        } catch {
            print("$Error: editing event: \(error)")
        }
    }
    
    // MARK: - Delete
    public func deleteStudiumObject(_ studiumEvent: StudiumEvent) {
        printDebug("Deleting studiumEvent \(studiumEvent.name)")
        
        // if we're deleting a course, delete all the assignments in the course
        if let course = studiumEvent as? Course {
            self.deleteAssignmentsForCourse(course: course)
        }

        do {
            try self.realm.write {
                self.realm.delete(studiumEvent)
            }
        } catch {
            print("$Error: error deleting studium object.")
        }
    }
    
    
    public func deleteAssignmentsForCourse(course: Course) {
        printDebug("Deleting assignments for course \(course.name)")
        for assignment in course.assignments {
            printDebug("Deleting assignment: \(assignment.name)")
            self.deleteStudiumObject(assignment)
//            do {
//                try self.realm.write {
//                    self.realm.delete(assignment)
//                }
//            } catch {
//                print("$Error: error deleting assignment object.")
//            }
        }
    }
}

extension DatabaseService: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (DatabaseService): \(message)")
        }
    }
}
