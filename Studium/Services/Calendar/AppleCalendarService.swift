//
//  AppleCalendarService.swift
//  Studium
//
//  Created by Vikram Singh on 5/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import EventKit
import VikUtilityKit

protocol AppleCalendarEvent {
    var ekEventID: String? { get set }
}


/// Service to interact with Apple Calendar (through EventKit)
class AppleCalendarService {
    
    /// Singleton
    static let shared = AppleCalendarService()
    
    private init() {}

    private let eventStore = EKEventStore()
    
    private let calendarName = "Studium Calendar"
    
    // MARK: - Create
    
    /// Creates a new Apple Calendar event
    /// - Parameters:
    ///   - studiumEvent: The StudiumEvent for which we want to create the apple calendar event
    ///   - completion: Completion Handler
    func createEvent(
        forStudiumEvent studiumEvent: StudiumEvent,
        completion: @escaping (Result<EKEvent, Error>) -> Void
    ) {
        
        // Avoid creating double events
        DispatchQueue.main.async {
            if self.getEKEvent(forStudiumEvent: studiumEvent) != nil {
                return
            }
            
            // Event is not recurring
            let newEvent = EKEvent(eventStore: self.eventStore)
            newEvent.title = studiumEvent.name
            newEvent.startDate = studiumEvent.startDate
            newEvent.endDate = studiumEvent.endDate
            newEvent.calendar = self.getAppCalendar()
            
            // Event is recurring
            if let recurringEvent = studiumEvent as? RecurringStudiumEvent {
                // Add the recurrence rules for the event
                self.resetRecurrenceRules(forRecurringEvent: recurringEvent)
            }
            
            self.saveEvent(newEvent, completion: completion)
        }
    }
    
    // MARK: - Read
    
    /// Gets the Apple calendar event that corresponds to a StudiumEvent
    /// - Parameter studiumEvent: The StudiumEvent for which we want to retrieve the Apple Calendar event
    /// - Returns: The Apple Calendar event
    private func getEKEvent(forStudiumEvent studiumEvent: StudiumEvent) -> EKEvent? {
        if let eventID = studiumEvent.ekEventID {
            return self.eventStore.event(withIdentifier: eventID)
        }
        
        return nil
    }
    
    /// Gets the Apple Calendar for the app
    /// - Returns: The Apple Calendar for the app
    private func getAppCalendar() -> EKCalendar {
        
        // Attempt to retrieve the already existing calendar
        if let calendarID = UserDefaultsService.shared.getAppleCalendarID(),
           let calendar = self.eventStore.calendar(withIdentifier: calendarID) {
            //            self.calendar = calendar
            //            completion(.success(calendar))
            return calendar
        }
        
        // There is no existing calendar, so create a new one
        let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
        newCalendar.title = self.calendarName
        newCalendar.source = self.eventStore.defaultCalendarForNewEvents?.source
        newCalendar.cgColor = StudiumColor.primaryAccent.uiColor.cgColor
        
        do {
            try self.eventStore.saveCalendar(newCalendar, commit: true)
            UserDefaultsService.shared.setAppleCalendarID(newCalendar.calendarIdentifier)
            return newCalendar
        } catch let error {
            Log.e(error)
            return newCalendar
        }
    }
    
    // MARK: - Update
    
    /// Updates an existing Apple Calendar event that corresponds to a StudiumEvent
    /// - Parameters:
    ///   - studiumEvent: The StudiumEvent for which we want to update the Apple Calendar event
    ///   - completion: Completion handler
    func updateEvent(
        forStudiumEvent studiumEvent: StudiumEvent,
        completion: @escaping (Result<EKEvent, Error>) -> Void
    ) {
        guard let event = self.getEKEvent(forStudiumEvent: studiumEvent) else {
            Log.e("Tried to retrieve EKEvent for studiumEvent \(studiumEvent) when updating but couldn't.")
            completion(.failure(AppleCalendarServiceError.failedToRetrieveEventFromID))
            return
        }
        
        event.title = studiumEvent.name
        event.startDate = studiumEvent.startDate
        event.endDate = studiumEvent.endDate
        event.location = studiumEvent.location
        event.notes = studiumEvent.additionalDetails
        
        if let recurringEvent = studiumEvent as? RecurringStudiumEvent {
            self.resetRecurrenceRules(forRecurringEvent: recurringEvent)
        }
        
        self.saveEvent(event, completion: completion)
    }
    
    
    /// Resets the weekly recurrence rules for an EKEvent
    /// - Parameters:
    ///   - event: The event for which we want to reset the rules
    ///   - days: The days on which the event occurs
    private func resetRecurrenceRules(forRecurringEvent recurringEvent: RecurringStudiumEvent) {
        if let ekEvent = self.getEKEvent(forStudiumEvent: recurringEvent) {
            let recurrenceRule = recurringEvent.ekRecurrenceRule
            ekEvent.recurrenceRules = [recurrenceRule]
            Log.g("successfully reset recurrence rules in apple calendar for \(recurringEvent.name)")
        } else {
            Log.e(AppleCalendarServiceError.failedToRetrieveEventFromID)
        }
    }
    
    // MARK: - Delete
    
    
    /// Deletes an event from the Apple Calendar that corresponds to a StudiumEvent
    /// - Parameters:
    ///   - studiumEvent: The StudiumEvent for which we want to delete the Apple Calendar Event
    ///   - completion: Completion handler in case of error
    func deleteEvent(forStudiumEvent studiumEvent: StudiumEvent, completion: @escaping (Error?) -> Void) {
        guard let event = self.getEKEvent(forStudiumEvent: studiumEvent) else {
            Log.e("Tried to retrieve EKEvent for studiumEvent \(studiumEvent) when deleting but couldn't.")
            completion(AppleCalendarServiceError.failedToRetrieveEventFromID)
            return
        }
        
        do {
            try self.eventStore.remove(event, span: .futureEvents, commit: true)
            Log.d("successfully deleted Apple Calendar Event for studiumEvent \(studiumEvent.name)")
            completion(nil)
        } catch let error {
            Log.s(error, additionalDetails: "Attempted to delete event \(event) but failed.")
            completion(error)
        }
    }
}

// MARK: - Utility

extension AppleCalendarService {
    
    // TODO: Docstrings
    private func saveEvent(_ event: EKEvent, completion: @escaping (Result<EKEvent, Error>) -> Void) {
        do {
            try self.eventStore.save(event, span: .futureEvents, commit: true)
            Log.g("successfully saved apple calendar event \(event.title ?? "")")
            completion(.success(event))
        } catch let error {
            Log.s(error, additionalDetails: "Attempted to save event \(event) but failed.")
            completion(.failure(error))
        }
    }
    
    // Request access to the user's calendar
    private func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        self.eventStore.requestAccess(to: .event) { (granted, error) in
            completion(granted)
        }
    }
    
    func syncCalendar(allEvents: [StudiumEvent], completion: @escaping (Result<[EKEvent], Error>) -> Void) {
        Log.d("Sync calendar called.")
        self.requestCalendarAccess { granted in
            Log.d("Attempted to request Apple Calendar Access. Granted: \(granted)")
            
            // Permission to access Apple Calendar has been granted
            if granted {
                let (events, errors) = self.createEvents(forStudiumEvents: allEvents)
                
                // Everything went as intended
                if errors.isEmpty {
                    PopUpService.shared.presentToast(title: "Successfully Synced with Apple Calendar", description: "We'll now add Studium events to your calendar!", popUpType: .success)
                } else {
                    // Synced but couldn't add some events.
                    PopUpService.shared.presentToast(title: "Failed to add some events", description: "We've connected with your calendar, but couldn't add some events.", popUpType: .failure)
                }
                
                completion(.success(events))
                
            } else {
                PopUpService.shared.presentToast(title: "Failed to Access Calendar", description: "Please allow Calendar Access: Settings > Studium > Calendars", popUpType: .failure)
                completion(.failure(AppleCalendarServiceError.failedToAccessCalendar))
            }
        }
    }
    
    private func createEvents(
        forStudiumEvents studiumEvents: [StudiumEvent]
    ) -> (events: [EKEvent], errors: [Error]) {
        var errors = [Error]()
        var events = [EKEvent]()
        
        // Go through all the StudiumEvents and create an EKEvent for each
        for studiumEvent in studiumEvents {
            self.createEvent(forStudiumEvent: studiumEvent) { result in
                switch result {
                    // Successfully created the event
                case .success(let event):
                    events.append(event)
                    
                    // Assign the ekEventID property in the StudiumEvent to the EKEvent's ID
                    DatabaseService.shared.updateAppleCalendarEventID(studiumEvent: studiumEvent, appleCalendarEventID: event.eventIdentifier)
                    
                    // Failed to create the event
                case .failure(let error):
                    errors.append(error)
                }
            }
        }
        
        return (events, errors)
    }
}

enum AppleCalendarServiceError: Error {
    case failedToAccessCalendar
    case failedToCreateWeekdayFromRawValue
    case failedToRetrieveEventFromID
}
