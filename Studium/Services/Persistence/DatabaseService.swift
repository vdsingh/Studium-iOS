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
    
    /// The Realm database instance
    var realm: Realm {
        
        
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
    public func saveStudiumObject<T: StudiumEvent>(_ studiumEvent: T, realmWriteCompletion: @escaping () -> Void) {
        // If the event is autoscheduling
        
        if let autoschedulingEvent = studiumEvent as? any Autoscheduling,
           autoschedulingEvent.autoscheduling {
               self.printDebug("event \(studiumEvent.name) is autoscheduling. will attempt to autoschedule now.")
            // create Autoschedule event objects. AutoscheduleService will save any created events
            let autoscheduledEvents = AutoscheduleService.shared.createAutoscheduledEvents(forAutoschedulingEvent: autoschedulingEvent)
               
               self.printDebug("Created and saved autoscheduled events: \(autoscheduledEvents)")
            
        }
        
        
        printDebug("saving event \(studiumEvent)")
        do {
            try self.realm.write {
                self.realm.add(studiumEvent)
                realmWriteCompletion()
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
    
    public func getStudiumEvent<T: Object>(withPrimaryKey id: ObjectId, type: T.Type) -> T? {
        if let studiumEvent = self.realm.object(ofType: T.self, forPrimaryKey: id) {
            return studiumEvent
        }
        
        return nil
    }
    
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
            completableEvent.complete = complete
        }
    }
    
    /// Edits an Updatable event
    /// - Parameters:
    ///   - oldEvent: The original event that we want to edit
    ///   - newEvent: A new event with the desired changes
    public func updateEvent<T: Updatable>(
        oldEvent: T,
        updatedEvent: T.EventType,
        realmWriteCompletion: @escaping () -> Void
    ) {
        printDebug("editing StudiumEvent. \nOld Event: \(oldEvent). \nNew Event: \(updatedEvent)")
        self.realmWrite {
            oldEvent.updateFields(withNewEvent: updatedEvent)
            realmWriteCompletion()
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
    
    public func updateGoogleCalendarEventID(studiumEvent: StudiumEvent, googleCalendarEventID: String) {
        self.realmWrite {
            studiumEvent.googleCalendarEventID = googleCalendarEventID
        }
    }

    
    // MARK: - Delete
    
    /// Deletes a Studium Object from the database
    /// - Parameter studiumEvent: The StudiumEvent to delete
    public func deleteStudiumObject(
        _ studiumEvent: StudiumEvent,
        eventWillDelete: @escaping () -> Void
    ) {
        Log.d("attempting to delete studiumEvent \(studiumEvent.name)")

        if let containerEvent = studiumEvent as? (any StudiumEventContainer) {
            while let event = containerEvent.containedEvents.first {
                self.deleteStudiumObject(event) { }
            }
        }
        
        if let autoschedulingEvent = studiumEvent as? (any Autoscheduling) {
            while let event = autoschedulingEvent.autoscheduledEvents.first {
                self.deleteStudiumObject(event) { }
            }
        }
        
        self.realmWrite {
            eventWillDelete()
            if !studiumEvent.isInvalidated {
                Log.d("Deleting studiumEvent \(studiumEvent.name)")
                self.realm.delete(studiumEvent)
                
            } else {
                Log.e("Tried to delete StudiumEvent \(studiumEvent), but it was invalidated.")
            }
        }
    }
    
    // TODO: Docstrings
    private func realmWrite(_ writeBlock: () -> Void) {
        do {
            try self.realm.safeWrite {
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
