//
//  StudiumEventService.swift
//  Studium
//
//  Created by Vikram Singh on 6/17/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation


/// This service wraps all the services for manipulating StudiumEvents (ex: DatabaseService, NotificationService, etc.)
class StudiumEventService {
    
    static let shared = StudiumEventService(
        databaseService: DatabaseService.shared,
        notificationService: NotificationService.shared,
        appleCalendarService: AppleCalendarService.shared,
        googleCalendarService: GoogleCalendarService.shared
    )
    
    private var databaseService: DatabaseService
    private var notificationService: NotificationService
    private var appleCalendarService: AppleCalendarService
    private var googleCalendarService: GoogleCalendarService

    init(
        databaseService: DatabaseService,
        notificationService: NotificationService,
        appleCalendarService: AppleCalendarService,
        googleCalendarService: GoogleCalendarService
    ) {
        self.databaseService = databaseService
        self.notificationService = notificationService
        self.appleCalendarService = appleCalendarService
        self.googleCalendarService = googleCalendarService
        
    }
    
    // MARK: - Create
    
    func saveStudiumEvent(_ studiumEvent: StudiumEvent) {
        
        // Save the event to the database
        self.databaseService.saveStudiumObject(studiumEvent) {
            
            // Save to Apple Calendar if Authorized
            if self.appleCalendarService.authorizationStatus() == .authorized {
                
                // Add an apple calendar event for the StudiumEvent
                self.appleCalendarService.createEvent(forStudiumEvent: studiumEvent) { result in
                    switch result {
                    case .success(let appleCalendarEvent):
                        Log.g("successfully created apple calendar event and linked it to StudiumEvent \(studiumEvent.name)")
                    case .failure(let error):
                        Log.e(error)
                        PopUpService.shared.presentToast(title: "Error Adding Event to Apple Calendar", description: "We were unable this event to Apple Calendar", popUpType: .failure)
                    }
                }
            }
            
            if self.googleCalendarService.calendarAuthorized {
                
                // Add a google calendar event for the StudiumEvent
                self.googleCalendarService.createEvent(storingEvent: studiumEvent) { result in
                    switch result {
                    case .success(let googleCalendarEvent):
                        if let identifier = googleCalendarEvent.identifier {
                            self.databaseService.updateGoogleCalendarEventID(studiumEvent: studiumEvent, googleCalendarEventID: identifier)
                            Log.g("successfully created google calendar event and linked to StudiumEvent \(studiumEvent.name)")
                        } else {
                            Log.e("successfully created google calendar event for StudiumEvent \(studiumEvent.name), but couldn't update the linking ID because it was nil")
                        }
                    case .failure(let error):
                        Log.e(error, additionalDetails: "calendar access is authorized but couldn't add event")
                        PopUpService.shared.presentToast(title: "Error Adding Event to Google Calendar", description: "We were unable this event to Google Calendar", popUpType: .failure)
                    }
                }
            } else {
                Log.d("didn't save event to google calendar (not authorized)")
            }
            
            // Schedule Notifications
            NotificationService.shared.scheduleNotificationsFor(event: studiumEvent)
        }
    }
    
    // MARK: - Update
    
    func updateStudiumEvent<T: Updatable>(
        oldEvent: T,
        updatedEvent: T.EventType
    ) {
        self.databaseService.updateEvent(oldEvent: oldEvent, updatedEvent: updatedEvent) {
            
            // Make sure event is StudiumEvent
            guard let oldEvent = oldEvent as? StudiumEvent else {
                Log.s(StudiumEventServiceError.invalidParameterType, additionalDetails: "updated event \(oldEvent), but it was not a StudiumEvent")
                return
            }
            
            // Schedule Notifications
            self.notificationService.scheduleNotificationsFor(event: oldEvent)
            
            if self.appleCalendarService.authorizationStatus() == .authorized {
                
                // Update Apple Calendar Event
                self.appleCalendarService.updateEvent(forStudiumEvent: oldEvent) { _ in }
            }
            
            if self.googleCalendarService.calendarAuthorized {
                
                // Update Google CalendarEvent
                self.googleCalendarService.updateEvent(event: oldEvent)
            } else {
                Log.d("attempted to update StudiumEvent on Google Calendar but was not authorized")
            }
        }
    }
    
    func markComplete(_ completableEvent: CompletableStudiumEvent, _ complete: Bool) {
        //TODO: Delete assignment notifications when complete, add when incomplete.
        
        self.databaseService.markComplete(completableEvent, complete)
    }
    
    // MARK: - Delete
    
    func deleteStudiumEvent(_ studiumEvent: StudiumEvent) {
        self.databaseService.deleteStudiumObject(studiumEvent) {
            NotificationService.shared.deleteAllPendingNotifications(for: studiumEvent)
            if self.appleCalendarService.authorizationStatus() == .authorized {
                self.appleCalendarService.deleteEvent(forStudiumEvent: studiumEvent) { _ in
                    studiumEvent.ekEventID = nil
                }
            }
            
            if self.googleCalendarService.calendarAuthorized {
                self.googleCalendarService.deleteEvent(event: studiumEvent)
            }
        }
    }
}

enum StudiumEventServiceError: Error {
    case invalidParameterType
}
