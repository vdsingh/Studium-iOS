//
//  GoogleCalendarService.swift
//  Studium
//
//  Created by Vikram Singh on 6/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import EventKit
import VikUtilityKit
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class GoogleCalendarService {
    
    static let shared = GoogleCalendarService()
    
    private let service = GTLRCalendarService()
    
    let calendarName = "Studium Calendar"
    
    var calendarAuthorized: Bool {
        return self.googleAccessToken != nil
    }
    
    private var calendarID: String? {
        get { return UserDefaultsService.shared.getGoogleCalendarID() }
        set { UserDefaultsService.shared.setGoogleCalendarID(newValue)}
    }
    
    var googleAccessToken: String? {
        return GIDSignIn.sharedInstance.currentUser?.accessToken.tokenString
//        get { return UserDefaultsService.shared.getGoogleAccessTokenString() }
//        set { UserDefaultsService.shared.setGoogleCalendarID(newValue) }
    }
    
    private init() {
        // Set up the service
        self.service.shouldFetchNextPages = true
        self.service.isRetryEnabled = true
        self.setAccessTokenHeader()
    }
    
    func setAccessTokenHeader() {
        if let googleAccessToken = self.googleAccessToken {
            self.service.additionalHTTPHeaders = ["Authorization" : "Bearer \(googleAccessToken)"]
        }
    }
    
    func authenticateWithCalendarScope(presentingViewController: UIViewController) {
        AuthenticationService.shared.authenticateWithGoogle(
            withScopes: [.calendarAPI],
            presentingViewController: presentingViewController
        ) { result in
            switch result {
            case .success(_):
                self.setAccessTokenHeader()
            case .failure(let error):
                PopUpService.shared.presentToast(title: "Failed to Access Calendar", description: "We couldn't access your Google calendar. Try again later.", popUpType: .failure)
                Log.e(error, additionalDetails: "Tried to authenticate in GoogleCalendarService but failed.")
            }
        }
    }
    
    func executeQuery(_ query: GTLRQuery, completionHandler: @escaping GTLRServiceCompletionHandler) {
        guard let googleAccessToken = self.googleAccessToken else {
            Log.e("attempted to execute query but googleAccessToken was nil")
            return
        }
        
        self.setAccessTokenHeader()
        self.service.executeQuery(query, completionHandler: completionHandler)
    }
    
    // MARK: - Create
    
    /// Creates and returns a GTLRCalendar Event that corresponds to any GoogleCalendarEventLinking event
    /// - Parameter storingEvent: The event that specifies the details for the Google Calendar Event
    /// - Returns:  a GTLRCalendar Event that corresponds to the specified GoogleCalendarEventLinking event
    func instantiateEvent(storingEvent: any GoogleCalendarEventLinking) -> GTLRCalendar_Event {
        let googleEvent = GTLRCalendar_Event()
        googleEvent.summary = storingEvent.name
        
        let startDateTime = GTLRDateTime(date: storingEvent.startDate)
        
        googleEvent.start = GTLRCalendar_EventDateTime()
        googleEvent.start?.timeZone = TimeZone.current.identifier
        googleEvent.start?.dateTime = startDateTime
        
        let endDateTime = GTLRDateTime(date: storingEvent.endDate)
        
        googleEvent.end = GTLRCalendar_EventDateTime()
        googleEvent.end?.timeZone = TimeZone.current.identifier
        googleEvent.end?.dateTime = endDateTime
        
        // If the event is recurring, set the recurrence rule
        if let storingEvent = storingEvent as? any GoogleCalendarRecurringEventLinking {
            let recurrenceRule = storingEvent.ekRecurrenceRule
            self.setRecurrenceRule(recurringEvent: googleEvent, recurrenceRule: recurrenceRule)
        }
        
        return googleEvent
    }
    
    /// Creates a google calendar event based on a linking event
    /// - Parameters:
    ///   - storingEvent: The event that is linked to the google calendar event
    ///   - completion: Completion handler
    func createEvent(
        storingEvent: any GoogleCalendarEventLinking,
        completion: @escaping (Result<GTLRCalendar_Event, Error>) -> Void
    ) {
        
        self.updateCalendar() {
            guard let calendarID = self.calendarID else {
                Log.s(GoogleCalendarServiceError.nilCalendarIDAfterUpdate, additionalDetails: "Attempted to get the calendarID, but failed even after calling updateCalendar")
                return
            }
            
            let googleEvent = self.instantiateEvent(storingEvent: storingEvent)
            
            self.insertEvent(
                event: googleEvent,
                calendarID: calendarID,
                completion: completion
            )
        }
    }
    
    // TODO: Docstrings
    private func insertEvent(
        event: GTLRCalendar_Event,
        calendarID: String,
        completion: @escaping (Result<GTLRCalendar_Event, Error>) -> Void
    ) {
        let eventInsertionQuery = GTLRCalendarQuery_EventsInsert.query(withObject: event, calendarId: calendarID)
        self.executeQuery(eventInsertionQuery) { (ticket, createdEvent, error) in
            if let error = error {
                Log.e(error, additionalDetails: "attempted to create google calendar event but failed")
                completion(.failure(error))
            } else {
                if let createdEvent = createdEvent as? GTLRCalendar_Event {
                    Log.g("successfully created google calendar event")
                    completion(.success(createdEvent))
                } else {
                    let unknownError = NSError(domain: "UnknownError", code: 0, userInfo: nil)
                    Log.e(unknownError, additionalDetails: "attempted to create google calendar event but failed with unknown error")
                    completion(.failure(unknownError))
                }
            }
        }
    }
    
    // TODO: Docstring
    func setRecurrenceRule(
        recurringEvent: GTLRCalendar_Event,
        recurrenceRule: EKRecurrenceRule
    ) {
        guard let daysOfTheWeek = recurrenceRule.daysOfTheWeek else {
            Log.e("setRecurrenceRule was called but")
            return
        }
        
        // Construct the recurrence rule string from the EKRecurrenceRule
        var recurrenceRuleString = "RRULE:FREQ=WEEKLY;INTERVAL=1;BYDAY="
        for day in daysOfTheWeek {
            let weekdayIntValue = day.dayOfTheWeek.rawValue
            if let studiumWeekday = Weekday(rawValue: weekdayIntValue) {
                recurrenceRuleString += "\(studiumWeekday.rfc5545Value),"
            }
        }
        
        // Remove the trailing comma
        recurrenceRuleString.removeLast()
        recurringEvent.recurrence = [recurrenceRuleString]
    }
    
    /// Creates a calendar on the user's Google Calendar, stores the ID of the calendar
    private func createCalendar(completion: @escaping () -> Void) {
        let calendar = GTLRCalendar_Calendar()
        calendar.summary = "Studium Calendar"
        calendar.descriptionProperty = "This calendar holds events from Studium."
        
        let calendarCreationQuery = GTLRCalendarQuery_CalendarsInsert.query(withObject: calendar)
        
        self.executeQuery(calendarCreationQuery) { (ticket, createdCalendar, error) in
            if let error = error {
                Log.e(error, additionalDetails: "Tried to create Google Calendar but failed.")
                
                // Successfully created the calendar:
            } else if let createdCalendar = createdCalendar as? GTLRCalendar_Calendar {
                Log.g("Calendar created successfully with ID: \(createdCalendar.identifier ?? "")")
                if let calendarID = createdCalendar.identifier {
                    
                    // Store the ID of the google calendar (to fetch later)
                    self.calendarID = calendarID
                    completion()
                } else {
                    Log.e("Google calendar was successfully created, but its ID is nil.")
                }
            } else {
                Log.e("Unknown error occurred while creating the calendar.")
            }
        }
    }
    
    // MARK: - Read
    
    /// Fetches a google calendar event based on its ID
    /// - Parameters:
    ///   - eventID: The ID of the google calendar event
    ///   - completion: Completion handler
    func getEvent(eventID: String, completion: @escaping (Result<GTLRCalendar_Event, Error>) -> Void) {
        self.updateCalendar {
            guard let calendarID = self.calendarID else {
                Log.s(GoogleCalendarServiceError.nilCalendarIDAfterUpdate, additionalDetails: "getEvent with eventID: \(eventID)")
                completion(.failure(GoogleCalendarServiceError.nilCalendarIDAfterUpdate))
                return
            }
            
            let fetchEventQuery = GTLRCalendarQuery_EventsGet.query(withCalendarId: calendarID, eventId: eventID)
            
            self.executeQuery(fetchEventQuery) { (ticket, event, error) in
                if let error = error {
                    completion(.failure(error))
                } else if let event = event as? GTLRCalendar_Event {
                    completion(.success(event))
                } else {
                    let unknownError = NSError(domain: "UnknownError", code: 0, userInfo: nil)
                    completion(.failure(unknownError))
                }
            }
        }
    }
    
    // MARK: - Update
    
    func updateEvent(
        googleCalendarEventID: String?,
        updatedEvent: any GoogleCalendarEventLinking,
        completion: @escaping (Result<GTLRCalendar_Event, Error>) -> Void
    ) {
        Log.d("attempted to update event with ID \(String(describing: googleCalendarEventID)) from Google Calendar")
        
        // Update the calendar
        self.updateCalendar() {
            guard let calendarID = self.calendarID else {
                Log.s(GoogleCalendarServiceError.nilCalendarIDAfterUpdate, additionalDetails: "Attempted to get the calendarID in deleteEvent, but failed even after calling updateCalendar")
                completion(.failure(GoogleCalendarServiceError.nilCalendarIDAfterUpdate))
                return
            }
            
            guard let googleCalendarEventID = googleCalendarEventID else {
                Log.e(GoogleCalendarServiceError.nilEventID, additionalDetails: "tried to delete google calendar event, but it was nil")
                completion(.failure(GoogleCalendarServiceError.nilEventID))
                return
            }
            
            let updatedGoogleCalendarEvent = self.instantiateEvent(storingEvent: updatedEvent)
            
            self.getEvent(eventID: googleCalendarEventID, completion: { result in
                switch result {
                case .success(let event):
                    let updateQuery = GTLRCalendarQuery_EventsUpdate.query(
                        withObject: updatedGoogleCalendarEvent,
                        calendarId: calendarID,
                        eventId: googleCalendarEventID
                    )
                    
                    self.executeQuery(updateQuery) { (ticket, event, error) in
                        if let error = error {
                            Log.e(error, additionalDetails: "Attempted to update Google Calendar Event with id \(googleCalendarEventID), but failed when executing the service request.")
                            completion(.failure(error))
                        } else if let event = event as? GTLRCalendar_Event {
                            completion(.success(event))
                        } else {
                            Log.e(GoogleCalendarServiceError.nilEvent, additionalDetails: "Attempted to update Google Calendar Event with id \(googleCalendarEventID) and succeeded, but the event was nil.")
                            completion(.failure(GoogleCalendarServiceError.nilEvent))
                        }
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        }
    }
    
    /// Fetches the Google Calendar for this app, or creates one if there isn't one (and stores its ID)
    func updateCalendar(completion: @escaping () -> Void) {
        
        // Check if we already have a calendar ID. If so, fetch the calendar
        if let calendarID = self.calendarID {
            let calendarFetchQuery = GTLRCalendarQuery_CalendarListGet.query(withCalendarId: calendarID)
            
            self.executeQuery(calendarFetchQuery) { (ticket, calendar, error) in

                // Couldn't fetch the calendar
                if let error = error {
                    Log.e(error, additionalDetails: "Attempted to fetch calendar from id: \(calendarID) but failed. The googleAccessToken is \(String(describing: self.googleAccessToken))")
                    completion()
                } else if let calendar = calendar as? GTLRCalendar_CalendarListEntry {
                    Log.g("successfully fetched calendar \(String(describing: calendar.summary))")
                    completion()
                } else {
                    let unknownError = NSError(domain: "UnknownError", code: 0, userInfo: nil)
                    Log.e(unknownError, additionalDetails: "Unknown error trying to fetch a google calendar")
                    self.createCalendar(completion: completion)
                }
            }
        } else {
            self.createCalendar(completion: completion)
        }
    }
    
    // MARK: - Delete
    
    func deleteEvent(
        googleCalendarEventID: String?,
        completion: @escaping (Error?) -> Void
    ) {
        Log.d("attempted to delete event with ID \(String(describing: googleCalendarEventID)) from Google Calendar")
        self.updateCalendar() {
            guard let calendarID = self.calendarID else {
                Log.s(GoogleCalendarServiceError.nilCalendarIDAfterUpdate, additionalDetails: "Attempted to get the calendarID in deleteEvent, but failed even after calling updateCalendar")
                completion(GoogleCalendarServiceError.nilCalendarIDAfterUpdate)
                return
            }
            
            guard let googleCalendarEventID = googleCalendarEventID else {
                Log.e(GoogleCalendarServiceError.nilEventID, additionalDetails: "tried to delete google calendar event, but it was nil")
                completion(GoogleCalendarServiceError.nilEventID)
                return
            }
            
            let deletionQuery = GTLRCalendarQuery_EventsDelete.query(withCalendarId: calendarID, eventId: googleCalendarEventID)
            
            self.executeQuery(deletionQuery) { (ticket, _, error) in
                if let error = error {
                    Log.e(error, additionalDetails: "Attempted to delete Google Calendar Event with id \(googleCalendarEventID), but failed when executing the service request.")
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
    }
}

enum GoogleCalendarServiceError: Error {
    case nilCalendarIDAfterUpdate
    case nilEventID
    case nilEvent
}
