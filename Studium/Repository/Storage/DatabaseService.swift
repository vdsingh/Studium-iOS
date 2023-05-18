//
//  DatabaseHandler.swift
//  Studium
//
//  Created by Vikram Singh on 1/26/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import VikUtilityKit

//TODO: Docstrings
protocol DatabaseServiceProtocol {
    func saveStudiumObject(_ studiumEvent: StudiumEvent)
    func saveAssignment(assignment: Assignment, parentCourse: Course)
    func getStudiumObjects <T: StudiumEvent> (expecting type: T.Type) -> [T]
    func getAllStudiumObjects() -> [StudiumEvent]
    func getAssignments(forCourse course: Course) -> [Assignment]
    func getUserSettings() -> UserSettings
    func markComplete(_ completableEvent: CompletableStudiumEvent, _ complete: Bool)
    func editStudiumEvent(oldEvent: StudiumEvent, newEvent: StudiumEvent)
    func setWakeUpTime(for weekday: Weekday, wakeUpTime: Date)
    func deleteStudiumObject(_ studiumEvent: StudiumEvent)
//    func deleteAssignmentsForCourse(course: Course)
    func setDefaultAlertOptions(alertOptions: [AlertOption])
    func getDefaultAlertOptions() -> [AlertOption]
}

/// Service to interact with the Realm Database
final class DatabaseService: DatabaseServiceProtocol {
    
    let debug = true
    
//    var autoscheduleService: AutoscheduleServiceProtocol!
    
    static let shared = DatabaseService()
    
    init() {
//        self.autoscheduleService = autoscheduleService
//        self.setAutoscheduleService(autoscheduleService: AutoscheduleService.shared)
    }
    
//    func setAutoscheduleService(autoscheduleService: AutoscheduleServiceProtocol) {
//        self.autoscheduleService = autoscheduleService
//    }
//
    /// Represents the application for Realm
//    let app = App(id: Secret.appID)
//
//    /// Represents the User for Realm
//    var user: User? {
//        guard let user = app.currentUser else {
//            print("$ERR: Current User is nil")
//            return nil
//        }
//
//        return user
//    }
    
    /// The Realm database instance
    private var realm: Realm {
        // If the user exists, establish a connection to realm using the User's ID
        if let user = AuthenticationService.shared.user {
            do {
                return try Realm(configuration: user.configuration(partitionValue: user.id))
            } catch let error {
                fatalError("$ERR: issue accessing Realm: \(String(describing: error))")
            }
        } else {
            fatalError("$ERR: tried to access Realm before user logged in")
        }
    }
    
    //MARK: - Create
    
    /// Saves a StudiumEvent to the database
    /// - Parameter studiumEvent: The StudiumEvent to save to the database
    public func saveStudiumObject(_ studiumEvent: StudiumEvent) {
        
        // The event is an assignment
        if let assignment = studiumEvent as? Assignment {
            guard let parentCourse = assignment.parentCourse else {
                print("$ERR (DatabaseService): tried to save assignment but its parent course was nil")
                return
            }
            
            self.saveAssignment(assignment: assignment, parentCourse: parentCourse)
            return
        }
        
        printDebug("saving event \(studiumEvent)")
        do {
            try self.realm.write {
                self.realm.add(studiumEvent)
                NotificationService.shared.scheduleNotificationsFor(event: studiumEvent)
            }
        } catch {
            print("$ERR: error deleting studium object.")
        }
    }
    
    
    /// Saves an Assignment to the Database under a specified Course
    /// - Parameters:
    ///   - assignment: The Assignment to save
    ///   - parentCourse: The Course that the Assignment belongs to
    ///   - parentAssignment: The parentAssignment for the assignment (if the assignment is autoscheduled study time)
    public func saveAssignment(assignment: Assignment, parentCourse: Course) {
        printDebug("Saving assignment: \(assignment.name).")
        
        self.realmWrite {
            parentCourse.appendAssignment(assignment)
            if let parentAssignmentID = assignment.parentAssignmentID {
                if let parentAssignment = self.realm.object(ofType: Assignment.self, forPrimaryKey: parentAssignmentID) {
//                    parentAssignment.scheduledEvents.append(assignment)
                    parentAssignment.appendScheduledEvent(event: assignment)
                } else {
                    print("$ERR (DatabaseService): tried to save autoscheduled assignment, but couldn't retrieve the parent assignment from its primary key.")
                }
            }
            NotificationService.shared.scheduleNotificationsFor(event: assignment)
        }
    }
    
    // MARK: - Read
    
    /// Retrieves all of the StudiumEvents of a certain type
    /// - Parameter type: The type of StudiumEvent we want to retrieve
    /// - Returns: All StudiumEvent objects of the specified type
    public func getStudiumObjects <T: StudiumEvent> (expecting type: T.Type) -> [T] {
        return [T](self.realm.objects(type))
    }
    
    /// Gets all of the StudiumEvents in the database
    /// - Returns: All of the StudiumEvents in the database
    public func getAllStudiumObjects() -> [StudiumEvent] {
        let courses = self.getStudiumObjects(expecting: Course.self)
        let habits = self.getStudiumObjects(expecting: Habit.self)
        let assignments = self.getStudiumObjects(expecting: Assignment.self)
        let otherEvents = self.getStudiumObjects(expecting: OtherEvent.self)
        
        var allEvents = [StudiumEvent]()
        allEvents.append(contentsOf: courses)
        allEvents.append(contentsOf: habits)
        allEvents.append(contentsOf: assignments)
        allEvents.append(contentsOf: otherEvents)
        
        return allEvents
    }
    
    /// Retrieves all of the Assignments for a given Course
    /// - Parameter course: The Course that we want to retrieve the Assignments for
    /// - Returns: All of the Assignments for the provided Course
    public func getAssignments(forCourse course: Course) -> [Assignment] {
        return [Assignment](course.scheduledEvents)
    }
    
    /// Retrieves the UserSettings object from the database
    /// - Returns: The UserSettings object from the database
    public func getUserSettings() -> UserSettings {
        let settings = [UserSettings](self.realm.objects(UserSettings.self))
        
        do {
            if let first = settings.first {
                return first
            } else {
                let settings = UserSettings()
                try self.realm.write {
                    self.realm.add(settings)
                }
                
                return settings
            }
        } catch let error {
            // Error handling
            print("$ERR (DatabaseService): \(error.localizedDescription)")
        }
        
        return UserSettings()
    }
    
    public func getDefaultAlertOptions() -> [AlertOption] {
        let settings = self.getUserSettings()
        return settings.defaultAlertOptions
    }
    
    // MARK: - Update
    
    /// Sets the completion status of a Completable Event
    /// - Parameters:
    ///   - completableEvent: The event for which we want to set the completion status
    ///   - complete: Whether or not the event should be complete or not
    public func markComplete(_ completableEvent: CompletableStudiumEvent, _ complete: Bool) {
        //TODO: Delete assignment notifications when complete, add when incomplete.
        self.realmWrite {
            completableEvent.complete = !completableEvent.complete
        }
    }
    
    /// Edits a StudiumEvent
    /// - Parameters:
    ///   - oldEvent: The original event that we want to edit
    ///   - newEvent: A new event with the desired changes
    public func editStudiumEvent(oldEvent: StudiumEvent, newEvent: StudiumEvent) {
        printDebug("editing StudiumEvent. \nOld Event: \(oldEvent). \nNew Event: \(newEvent)")
        newEvent.setID(oldEvent._id)
        
        self.realmWrite {
            self.realm.add(newEvent, update: .modified)
            NotificationService.shared.scheduleNotificationsFor(event: newEvent)
        }
    }
    
    /// Sets the user's wake up time for a given day
    /// - Parameters:
    ///   - weekday: The day for which to set the wake up time
    ///   - wakeUpTime: The time that the user plans to wake up
    public func setWakeUpTime(for weekday: Weekday, wakeUpTime: Date) {
        let settings = self.getUserSettings()
        self.realmWrite {
            settings.setWakeUpTime(for: weekday, wakeUpTime: wakeUpTime)
        }
    }
    
    public func setDefaultAlertOptions(alertOptions: [AlertOption]) {
        let settings = self.getUserSettings()
        self.realmWrite {
            settings.setDefaultAlertOptions(alertOptions: alertOptions)
        }
    }
    
    // MARK: - Delete
    
    /// Deletes a Studium Object from the database
    /// - Parameter studiumEvent: The StudiumEvent to delete
    public func deleteStudiumObject(_ studiumEvent: StudiumEvent) {
        
        printDebug("attempting to delete studiumEvent \(studiumEvent.name)")

        if let containerEvent = studiumEvent as? (any StudiumEventContainer) {
            while let event = containerEvent.scheduledEvents.first {
                self.deleteStudiumObject(event)
            }
        }
        
        self.realmWrite {
            NotificationService.shared.deleteAllPendingNotifications(for: studiumEvent)
            if !studiumEvent.isInvalidated {
                printDebug("Deleting studiumEvent \(studiumEvent.name)")
                self.realm.delete(studiumEvent)
            } else {
                print("$ERR (DatabaseService): Tried to delete StudiumEvent \(studiumEvent), but it was invalidated.")
            }
        }
    }
    
    
    /// Deletes all of the assignments for a Course
    /// - Parameter course: The Course that we want to delete the assignments for
//    public func deleteAssignmentsForCourse(course: Course) {
//        for assignment in course.assignments {
//            self.deleteStudiumObject(assignment)
//        }
//    }
    
    private func realmWrite(_ writeBlock: () -> Void) {
        do {
            try self.realm.write {
                writeBlock()
            }
        } catch let error {
            print("$ERR (DatabaseService): \(String(describing: error))")
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
