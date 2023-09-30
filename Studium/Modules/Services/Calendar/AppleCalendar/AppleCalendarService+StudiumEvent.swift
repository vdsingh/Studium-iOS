//
//  AppleCalendarService+StudiumEvent.swift
//  Studium
//
//  Created by Vikram Singh on 6/19/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import EventKit
import RealmSwift

extension AppleCalendarService {
    
    // MARK: - Create
    
    /// Creates a new Apple Calendar event
    /// - Parameters:
    ///   - studiumEvent: The StudiumEvent for which we want to create the apple calendar event
    ///   - completion: Completion Handler
    func createEvent(
        forStudiumEvent studiumEvent: StudiumEvent,
        completion: @escaping (Result<EKEvent, Error>) -> Void
    ) {

        // There is already an Apple Calendar event for the StudiumEvent
        if let event = self.getEKEvent(forStudiumEvent: studiumEvent) {
            completion(.success(event))
            return
        }
        
        // Create a new Apple Calendar event
        let event = self.createEKEvent(title: studiumEvent.name, startDate: studiumEvent.startDate, endDate: studiumEvent.endDate, location: studiumEvent.location, notes: studiumEvent.additionalDetails)
        
        // Event is recurring, add the recurrence rules
        if let recurringEvent = studiumEvent as? RecurringStudiumEvent {
            self.resetRecurrenceRules(forRecurringEvent: recurringEvent, ekEvent: event)
        }
        
        // Save the event
        self.saveEKEvent(event) { result in
            switch result {
            case .success(let event):
                // Link the StudiumEvent to the Apple Calendar Event
                DatabaseService.shared.updateAppleCalendarEventID(studiumEvent: studiumEvent, appleCalendarEventID: event.eventIdentifier)
                completion(.success(event))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Read
    
    /// Gets the Apple calendar event that corresponds to a StudiumEvent
    /// - Parameter studiumEvent: The StudiumEvent for which we want to retrieve the Apple Calendar event
    /// - Returns: The Apple Calendar event
    private func getEKEvent(forStudiumEvent studiumEvent: StudiumEvent) -> EKEvent? {
        if let eventID = studiumEvent.ekEventID {
            return self.getEKEvent(withID: eventID)
        }
        
        return nil
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
        if self.isAuthorized {
            guard let event = self.getEKEvent(forStudiumEvent: studiumEvent) else {
                Log.e("Tried to retrieve EKEvent for studiumEvent \(studiumEvent) when updating but couldn't.")
                completion(.failure(AppleCalendarServiceError.failedToRetrieveEventFromID))
                return
            }
            
            self.updateEKEvent(event: event, title: studiumEvent.name, startDate: studiumEvent.startDate, endDate: studiumEvent.endDate, location: studiumEvent.location, notes: studiumEvent.additionalDetails)
            
            if let recurringEvent = studiumEvent as? RecurringStudiumEvent {
                self.resetRecurrenceRules(forRecurringEvent: recurringEvent, ekEvent: event)
            }
            
            self.saveEKEvent(event, completion: completion)
        } else {
            Log.w("event for StudiumEvent \(studiumEvent.name) was not updated in apple calendar due to invalid authorization status")
            completion(.failure(AppleCalendarServiceError.invalidAuthorizationStatus))
        }
    }
    
    /// Resets the weekly recurrence rules for an EKEvent
    /// - Parameters:
    ///   - event: The event for which we want to reset the rules
    ///   - days: The days on which the event occurs
    private func resetRecurrenceRules(forRecurringEvent recurringEvent: RecurringStudiumEvent, ekEvent: EKEvent) {
        let recurrenceRule = recurringEvent.ekRecurrenceRule
        ekEvent.recurrenceRules = [recurrenceRule]
        Log.g("successfully reset recurrence rules in apple calendar for \(recurringEvent.name)")
    }
    
    // MARK: - Delete
    
    /// Deletes an event from the Apple Calendar that corresponds to a StudiumEvent
    /// - Parameters:
    ///   - studiumEvent: The StudiumEvent for which we want to delete the Apple Calendar Event
    ///   - completion: Completion handler in case of error
    func deleteEvent(
        forStudiumEvent studiumEvent: StudiumEvent,
        completion: @escaping (Error?) -> Void
    ) {
        guard let event = self.getEKEvent(forStudiumEvent: studiumEvent) else {
            Log.e("Tried to retrieve EKEvent for studiumEvent \(studiumEvent) when deleting but couldn't.")
            completion(AppleCalendarServiceError.failedToRetrieveEventFromID)
            return
        }
        
        self.deleteEKEvent(event: event, completion: completion)
    }
        
    // MARK: - Sync/Unsync
    
    /// Unsync from the apple calendar by deleting all apple calendar events and marking isSynced to false
    /// - Parameter completion: Completion once unsync has finished
    func unsyncCalendar(completion: @escaping () -> Void) {
        let allStudiumEvents = DatabaseService.shared.getAllStudiumObjects()

        if allStudiumEvents.isEmpty {
            completion()
        } else {
            for i in 0..<allStudiumEvents.count {
                let studiumEvent = allStudiumEvents[i]
                self.deleteEvent(forStudiumEvent: studiumEvent) { error in
                    if let error {
                        Log.e(error, additionalDetails: "Error deleting apple calendar event when unsyncing.")
                    }
                    
                    if i == allStudiumEvents.count - 1 {
                        completion()
                    }
                }
            }
        }
        
        self.showPopUp(popUpOption: .successfullyUnsynced)
        self.isSynced = false
    }
    
    
    /// Sync with the apple calendar by creating apple calendar events for all studium events and marking isSynced to true
    /// - Parameter completion: Completion once sync has finished
    func syncCalendar(
        completion: @escaping (Result<[EKEvent], Error>) -> Void
    ) {
        Log.d("Sync calendar called.")
        self.requestCalendarAccess { granted in
            Log.d("Attempted to request Apple Calendar Access. Granted: \(granted)")
            
            // Permission to access Apple Calendar has been granted
            if granted {
                
                // Retrieve all StudiumEvents within the thread they'll be used.
                let allStudiumEvents = DatabaseService.shared.getAllStudiumObjects() 
                                
                if allStudiumEvents.isEmpty {
                    completion(.success([]))
                } else {
                    // Iterate through all events
                    for i in 0..<allStudiumEvents.count {
                        var events = [EKEvent]()
                        let studiumEvent = allStudiumEvents[i]
                        
                        // Create an Apple Calendar event for the StudiumEvent
                        self.createEvent(forStudiumEvent: studiumEvent) { result in
                            switch result {
                            case .success(let event):
                                events.append(event)
                                Log.g("Created apple calendar event for event \(event)")
                            case .failure(let error):
                                Log.e(error, additionalDetails: "tried to add event \(studiumEvent) while syncing calendar but failed.")
                                self.showPopUp(popUpOption: .failedToAddEvent)
                            }
                            
                            // If this was the last event, call the completion handler
                            if i == allStudiumEvents.count - 1 {
                                completion(.success(events))
                            }
                        }
                    }
                }
                
                self.isSynced = true
                self.showPopUp(popUpOption: .successfullySynced)
            } else {
                self.showPopUp(popUpOption: .failedToAccessCalendar)
                completion(.failure(AppleCalendarServiceError.invalidAuthorizationStatus))
            }
        }
    }
}
