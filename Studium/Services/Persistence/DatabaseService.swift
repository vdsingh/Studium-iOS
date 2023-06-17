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

/// Service to interact with the Realm Database
final class DatabaseService: NSObject, DatabaseServiceProtocol, Debuggable {

    
    
    let debug = true
    
//    var autoscheduleService: AutoscheduleServiceProtocol!
    
    static let shared = DatabaseService()
    
//    init() {
//        self.autoscheduleService = autoscheduleService
//        self.setAutoscheduleService(autoscheduleService: AutoscheduleService.shared)
//    }
    
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
            AuthenticationService.shared.handleLogOut { error in
                if let error = error {
                    Log.e(error)
                }
            }
            
            fatalError("$ERR: tried to access Realm before user logged in. User Logged In: \(AuthenticationService.shared.userIsLoggedIn)")
        }
    }
    
    //MARK: - Create
    
    /// Saves a StudiumEvent to the database
    /// - Parameter studiumEvent: The StudiumEvent to save to the database
    public func saveStudiumObject<T: StudiumEvent>(_ studiumEvent: T) {
        
        // The event is an assignment
//        if let assignment = studiumEvent as? Assignment {
//            guard let parentCourse = assignment.parentCourse else {
//                Log.s(DatabaseServiceError.assignmentWithNilCourse, additionalDetails: "tried to save assignment \(assignment) but its parent course was nil")
//                return
//            }
//
//            self.saveAssignment(assignment: assignment, parentCourse: parentCourse)
//            return
//        }
        
        // If the event is autoscheduling
        
        if let autoschedulingEvent = studiumEvent as? any Autoscheduling,
           autoschedulingEvent.autoscheduling {
               
               self.printDebug("event \(studiumEvent.name) is autoscheduling. will attempt to autoschedule now.")
//            
//            // create Autoschedule event objects. AutoscheduleService will save any created events
            let autoscheduledEvents = AutoscheduleService.shared.createAutoscheduledEvents(forAutoschedulingEvent: autoschedulingEvent)
               
               self.printDebug("Created and saved autoscheduled events: \(autoscheduledEvents)")
//            
//            // save Autoschedule event objects
//            for unsavedAutoscheduledEvent in unsavedAutoscheduledEvents {
////                unsavedAutoscheduledEvent.save()
//                self.saveAutoscheduledEvent(
//                    autoschedulingEvent: autoschedulingEvent,
//                    autoscheduledEvent: unsavedAutoscheduledEvent
//                )
//            }
        }
        
//        if let scheduledEvent = studiumEvent as? (any StudiumEventContained) {
//            self.saveScheduledEvent(scheduledEvent: scheduledEvent, schedulingEvent: <#_#>)
//        }
        
        printDebug("saving event \(studiumEvent)")
        do {
            try self.realm.write {
                self.realm.add(studiumEvent)
                AppleCalendarService.shared.createEvent(forStudiumEvent: studiumEvent) { result in
                    switch result {
                    case .success(let event):
                        self.realmWrite {
                            studiumEvent.ekEventID = event.eventIdentifier
                        }
                    case .failure(let error):
                        Log.e(error)
                        PopUpService.shared.presentToast(title: "Error Syncing to Apple Calendar", description: "We were unable this event to Apple Calendar", popUpType: .failure)
                    }
                }
                
                NotificationService.shared.scheduleNotificationsFor(event: studiumEvent)
            }
        } catch let error {
            Log.s(error, additionalDetails: "tried to save studiumEvent \(studiumEvent) but failed.")
        }
    }
    
    func saveAutoscheduledEvent<T: Autoscheduling>(autoscheduledEvent: T.AutoscheduledEventType, autoschedulingEvent: T) {
        self.realmWrite {
            autoschedulingEvent.appendAutoscheduledEvent(event: autoscheduledEvent)
        }
    }
    
    func saveContainedEvent<T: StudiumEventContainer>(containedEvent: T.ContainedEventType, containerEvent: T) {
        self.realmWrite {
            containerEvent.appendContainedEvent(containedEvent: containedEvent)
        }
        
        // The contained event may be autoscheduling (ex: an Assignment that autoschedules work time)
        if let autoschedulingEvent = containedEvent as? any Autoscheduling,
           autoschedulingEvent.autoscheduling {
            
            self.printDebug("event \(autoschedulingEvent.name) is autoscheduling. will attempt to autoschedule now.")
            // create Autoschedule event objects. AutoscheduleService will save any created events
            let autoscheduledEvents = AutoscheduleService.shared.createAutoscheduledEvents(forAutoschedulingEvent: autoschedulingEvent)
            
            self.printDebug("Created and saved autoscheduled events: \(autoscheduledEvents)")
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
    
    // TODO: Docstrings
    public func getContainedEvents<T: StudiumEventContainer>(forContainer container: T) -> [T.ContainedEventType] {
        return container.containedEvents
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
    
    // TODO: Docstrings
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
    public func updateEvent<T: Updatable>(oldEvent: T, updatedEvent: T.EventType) {
        printDebug("editing StudiumEvent. \nOld Event: \(oldEvent). \nNew Event: \(updatedEvent)")
        self.realmWrite {
            oldEvent.updateFields(withNewEvent: updatedEvent)
            if let event = oldEvent as? StudiumEvent {
                NotificationService.shared.scheduleNotificationsFor(event: event)
                AppleCalendarService.shared.updateEvent(forStudiumEvent: event) {_ in}
            }
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
    
    // TODO: Docstrings
    public func setDefaultAlertOptions(alertOptions: [AlertOption]) {
        let settings = self.getUserSettings()
        self.realmWrite {
            settings.setDefaultAlertOptions(alertOptions: alertOptions)
        }
    }
    
    public func updateAppleCalendarEventID(studiumEvent: StudiumEvent, appleCalendarEventID: String) {
        self.realmWrite {
            studiumEvent.ekEventID = appleCalendarEventID
        }
    }

    
    // MARK: - Delete
    
    /// Deletes a Studium Object from the database
    /// - Parameter studiumEvent: The StudiumEvent to delete
    public func deleteStudiumObject(_ studiumEvent: StudiumEvent) {
        
        printDebug("attempting to delete studiumEvent \(studiumEvent.name)")

        if let containerEvent = studiumEvent as? (any StudiumEventContainer) {
            while let event = containerEvent.containedEvents.first {
                self.deleteStudiumObject(event)
            }
        }
        
        if let autoschedulingEvent = studiumEvent as? (any Autoscheduling) {
            while let event = autoschedulingEvent.autoscheduledEvents.first {
                self.deleteStudiumObject(event)
            }
        }
        
        self.realmWrite {
            NotificationService.shared.deleteAllPendingNotifications(for: studiumEvent)
            AppleCalendarService.shared.deleteEvent(forStudiumEvent: studiumEvent) { _ in
                studiumEvent.ekEventID = nil
            }
            
            if !studiumEvent.isInvalidated {
                printDebug("Deleting studiumEvent \(studiumEvent.name)")
                self.realm.delete(studiumEvent)
            } else {
                print("$ERR (DatabaseService): Tried to delete StudiumEvent \(studiumEvent), but it was invalidated.")
            }
        }
    }
    
    // TODO: Docstrings
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

enum DatabaseServiceError: Error {
    case assignmentWithNilCourse
}
