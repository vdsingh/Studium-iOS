//
//  MockDatabaseService.swift
//  Studium
//
//  Created by Vikram Singh on 5/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import VikUtilityKit

class MockDatabaseService: DatabaseServiceProtocol {
    func updateEvent<T>(oldEvent: T, updatedEvent: T.EventType) where T : Updatable {
        
    }
    


    
    
    //TODO: Implement
    func saveAutoscheduledEvent<T>(autoscheduledEvent: T.AutoscheduledEventType, autoschedulingEvent: T) where T : Autoscheduling {
        
    }
    
    //TODO: Implement
    func saveContainedEvent<T>(containedEvent: T.ContainedEventType, containerEvent: T) where T : StudiumEventContainer {
        
    }
    
    func getContainedEvents<T: StudiumEventContainer>(forContainer container: T) -> [T.ContainedEventType] {
        return []
    }
    
    
    
    
    
    var user: User? = nil
    
    static let shared = MockDatabaseService()
    
    private init() { }
    
    var events = [StudiumEvent]()
    
    func saveStudiumObject(_ studiumEvent: StudiumEvent) {
        self.events.append(studiumEvent)
    }
    
    func getStudiumObjects<T>(expecting type: T.Type) -> [T] where T : StudiumEvent {
        var events = [T]()
        for event in self.events {
            if let event = event as? T {
                events.append(event)
            }
        }
        
        return events
    }
    
    func getAllStudiumObjects() -> [StudiumEvent] {
        return self.events
    }
    
    
    func getUserSettings() -> UserSettings {
        return UserSettings()
    }
    
    func markComplete(_ completableEvent: CompletableStudiumEvent, _ complete: Bool) {
        completableEvent.complete = complete
    }
    
    func editStudiumEvent(oldEvent: StudiumEvent, newEvent: StudiumEvent) {
    }
    
    func setWakeUpTime(for weekday: Weekday, wakeUpTime: Date) {
        
    }
    
    func deleteStudiumObject(_ studiumEvent: StudiumEvent) {
        self.events.removeAll(where: { $0 == studiumEvent })
    }
    
    func setDefaultAlertOptions(alertOptions: [AlertOption]) {
        
    }
    
    func getDefaultAlertOptions() -> [AlertOption] {
        return []
    }
    
    func removeAllStudiumEvents() {
        self.events = [StudiumEvent]()
    }
}
