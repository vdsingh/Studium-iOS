//
//  AppleCalendarService.swift
//  Studium
//
//  Created by Vikram Singh on 5/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import EventKit
import SwiftUI

extension UserDefaultsKeys {
    /// Bool for whether the apple calendar is synced
    static let appleCalendarIsSynced = "appleCalendarIsSynced"
    
    /// String for the associated apple calendar ID
    static let appleCalendarID = "appleCalendarID"
}

/// Service to interact with Apple Calendar (through EventKit)
class AppleCalendarService: ObservableObject {
    
    /// Singleton instance
    static let shared = AppleCalendarService()

    /// Whether Studium is synced to apple calendar (stored in UserDefaults)
    @AppStorage(UserDefaultsKeys.appleCalendarIsSynced) var isSynced = false
    
    /// Apple Calendar ID
    @AppStorage(UserDefaultsKeys.appleCalendarID) var appleCalendarID: String = ""
    
    /// Whether the app is authorized to access the apple calendar
    var isAuthorized: Bool {
        if #available(iOS 17.0, *) {
            return self.authorizationStatus == .fullAccess
        } else {
            return self.authorizationStatus == .authorized
        }
    }
    
    /// The total number of events saved to apple calendar
    var totalEventCount: Int {
        let predicate = self.eventStore.predicateForEvents(withStart: .distantPast, end: .distantFuture, calendars: self.eventStore.calendars(for: .event))
        let events = self.eventStore.events(matching: predicate)
        Log.d("Apple calendar events: \(events)")
        return events.count
    }
    
    private let eventStore = EKEventStore()
    private let calendarName = "Studium Calendar"
    private let defaults: UserDefaults = .standard
    
    /// Force singleton usage
    private init() {}
    
    // MARK: - Create
    
    /// Saves an EKEvent to the EKEventStore
    /// - Parameters:
    ///   - event: The EKEvent to save to the store
    ///   - completion: Called after event has been saved (or an error occurred)
    func saveEKEvent(
        _ event: EKEvent,
        completion: @escaping (Result<EKEvent, Error>) -> Void
    ) {
        do {
            try self.eventStore.save(event, span: .futureEvents, commit: true)
            Log.g("successfully saved apple calendar event \(event.title ?? "")")
            completion(.success(event))
        } catch let error {
            Log.s(error, additionalDetails: "Attempted to save event \(event) but failed.")
            completion(.failure(error))
        }
    }
    
    /// Creates and returns an EKEvent with specified fields
    /// - Parameters:
    ///   - title: The title of the EKEvent
    ///   - startDate: The start date of the EKEvent
    ///   - endDate: The end date of the EKEvent
    ///   - location: The location of the EKEvent
    ///   - notes: Any additional notes or details associated with the EKEvent
    /// - Returns: The EKEvent
    func createEKEvent(
        title: String,
        startDate: Date,
        endDate: Date,
        location: String,
        notes: String
    ) -> EKEvent {
        let newEvent = EKEvent(eventStore: self.eventStore)
        self.updateEKEvent(event: newEvent, title: title, startDate: startDate, endDate: endDate, location: location, notes: notes)
        newEvent.calendar = self.getOrCreateAppCalendar()
        return newEvent
    }
    
    // MARK: - Read
    
    /// Gets the Apple Calendar for the app or creates one if there isn't one
    /// - Returns: The Apple Calendar for the app
    func getOrCreateAppCalendar() -> EKCalendar {
        
        // Attempt to retrieve the already existing calendar
        if !self.appleCalendarID.trimmed().isEmpty,
           let calendar = self.eventStore.calendar(withIdentifier: self.appleCalendarID) {
            return calendar
        }
        
        // There is no existing calendar, so create a new one
        let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
        newCalendar.title = self.calendarName
        newCalendar.source = self.eventStore.defaultCalendarForNewEvents?.source
        newCalendar.cgColor = StudiumColor.primaryAccent.uiColor.cgColor
        
        do {
            try self.eventStore.saveCalendar(newCalendar, commit: true)
            self.appleCalendarID = newCalendar.calendarIdentifier
            return newCalendar
        } catch let error {
            Log.e(error)
            return newCalendar
        }
    }
    
    /// Fetches an EKEvent by ID
    func getEKEvent(withID id: String) -> EKEvent? {
        return self.eventStore.event(withIdentifier: id)
    }
    
    // MARK: - Update
    
    // TODO: Docstrings
    func updateEKEvent(
        event: EKEvent,
        title: String,
        startDate: Date,
        endDate: Date,
        location: String,
        notes: String
    ) {
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.location = location
        event.notes = notes
    }
    
    
    // MARK: - Delete
    
    /// Deletes an EKEvent from the apple calendar
    /// - Parameters:
    ///   - event: The event to delete
    ///   - completion: Called once the event has been deleted (or an error has occurred)
    func deleteEKEvent(event: EKEvent, completion: @escaping (Error?) -> Void) {
        do {
            try self.eventStore.remove(event, span: .futureEvents, commit: true)
            Log.g("successfully deleted Apple Calendar Event")
            completion(nil)
        } catch let error {
            Log.s(error, additionalDetails: "Attempted to delete event \(event) but failed.")
            completion(error)
        }
    }
}

// MARK: - Utility

extension AppleCalendarService {
    private var authorizationStatus: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }

    /// Request access to the user's calendar
    /// - Parameter completion: Called after access has been requested (where the bool is 'granted')
    func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        switch self.authorizationStatus {
        case .notDetermined:
            if #available(iOS 17.0, *) {
                self.eventStore.requestFullAccessToEvents { granted, error in
                    completion(granted)
                }
            } else {
                self.eventStore.requestAccess(to: .event) { (granted, error) in
                    completion(granted)
                }
            }
            
        // FIXME: Show pop up for these cases
        case .restricted:
            completion(false)
        case .denied:
            completion(false)
        case .fullAccess:
            completion(true)
        case .writeOnly:
            completion(false)
        @unknown default:
            completion(false)
        }
    }
    
    // TODO: Move to PopUpService extension

    enum AppleCalendarServicePopUpOption {
        case failedToAccessCalendar
        case failedToAddEvent
        case successfullySynced
        case successfullyUnsynced
    }
    
    /// Users PopUpService to present a pop up to the user
    /// - Parameter popUpOption: The reason to show pop up
    func showPopUp(popUpOption: AppleCalendarServicePopUpOption) {
        switch popUpOption {
        case .failedToAccessCalendar:
            PopUpService.presentToast(title: "Failed to Access Calendar", description: "Please allow Calendar Access: Settings > Studium > Calendars", popUpType: .failure)
        case .failedToAddEvent:
            PopUpService.presentToast(title: "Failed to add an event", description: "We've connected with your calendar, but couldn't add an event.", popUpType: .failure)
        case .successfullySynced:
            PopUpService.presentToast(title: "Successfully Synced Apple Calendar", description: "Studium is not synced with your Apple Calendar.", popUpType: .success)
        case .successfullyUnsynced:
            PopUpService.presentToast(title: "Successfully Unsynced Apple Calendar", description: "All Apple calendar events have been removed.", popUpType: .success)
        }
    }
}

enum AppleCalendarServiceError: Error {
    case invalidAuthorizationStatus
    case failedToCreateWeekdayFromRawValue
    case failedToRetrieveEventFromID
}
