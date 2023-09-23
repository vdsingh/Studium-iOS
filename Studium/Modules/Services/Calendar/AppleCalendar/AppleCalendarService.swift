//
//  AppleCalendarService.swift
//  Studium
//
//  Created by Vikram Singh on 5/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import EventKit


protocol AppleCalendarEvent {
    var ekEventID: String? { get set }
}


/// Service to interact with Apple Calendar (through EventKit)
class AppleCalendarService {
    
    /// Singleton
    static let shared = AppleCalendarService()
    
    private init() {}
    
    // TODO: Docstrings
    let eventStore = EKEventStore()
    
    // TODO: Docstrings
    private let calendarName = "Studium Calendar"
    
    // MARK: - Create
    
    // TODO: Docstrings
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
    
    // TODO: Docstrings
    func createEKEvent(
        title: String,
        startDate: Date,
        endDate: Date,
        location: String,
        notes: String
    ) -> EKEvent {
        let newEvent = EKEvent(eventStore: self.eventStore)
        self.updateEKEvent(event: newEvent, title: title, startDate: startDate, endDate: endDate, location: location, notes: notes)
        newEvent.calendar = self.getAppCalendar()
        return newEvent
    }
    
    // MARK: - Read
    
    /// Gets the Apple Calendar for the app
    /// - Returns: The Apple Calendar for the app
    func getAppCalendar() -> EKCalendar {
        
        // Attempt to retrieve the already existing calendar
        if let calendarID = UserDefaultsService.shared.getAppleCalendarID(),
           let calendar = self.eventStore.calendar(withIdentifier: calendarID) {
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
    
    // TODO: Docstrings
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
    
    // TODO: Docstrings
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
    
    // TODO: Docstring
    // Request access to the user's calendar
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
    
    // TODO: Docstring
//    func authorizationStatus() -> EKAuthorizationStatus {
    var authorizationStatus: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }
    
    enum AppleCalendarServicePopUpOption {
        case failedToAccessCalendar
        case failedToAddEvent
        case successfullySynced
    }
    
    // TODO: Docstring
    func showPopUp(popUpOption: AppleCalendarServicePopUpOption) {
        switch popUpOption {
        case .failedToAccessCalendar:
            PopUpService.presentToast(title: "Failed to Access Calendar", description: "Please allow Calendar Access: Settings > Studium > Calendars", popUpType: .failure)
        case .failedToAddEvent:
            PopUpService.presentToast(title: "Failed to add an event", description: "We've connected with your calendar, but couldn't add an event.", popUpType: .failure)
        case .successfullySynced:
            PopUpService.presentToast(title: "Successfully Synced Calendar", description: "Events will now sync to your Apple Calendar.", popUpType: .success)
        }
    }
}

enum AppleCalendarServiceError: Error {
    case invalidAuthorizationStatus
    case failedToCreateWeekdayFromRawValue
    case failedToRetrieveEventFromID
}
