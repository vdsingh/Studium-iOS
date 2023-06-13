//
//  DatabaseServiceProtocol.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import VikUtilityKit

//TODO: Docstrings
protocol DatabaseServiceProtocol {
    
    // Create
    func saveStudiumObject(_ studiumEvent: StudiumEvent)
    func saveContainedEvent<T: StudiumEventContainer>(containedEvent: T.ContainedEventType, containerEvent: T)
    func saveAutoscheduledEvent<T: Autoscheduling>(autoscheduledEvent: T.AutoscheduledEventType, autoschedulingEvent: T)
    func setDefaultAlertOptions(alertOptions: [AlertOption])

    // Read
    func getStudiumObjects <T: StudiumEvent> (expecting type: T.Type) -> [T]
    func getAllStudiumObjects() -> [StudiumEvent]
//    func getAssignments(forCourse course: Course) -> [Assignment]
    func getContainedEvents<T: StudiumEventContainer>(forContainer container: T) -> [T.ContainedEventType]
    func getUserSettings() -> UserSettings
    func getDefaultAlertOptions() -> [AlertOption]

    // Update
    func markComplete(_ completableEvent: CompletableStudiumEvent, _ complete: Bool)
    func editStudiumEvent(oldEvent: StudiumEvent, newEvent: StudiumEvent)
    func setWakeUpTime(for weekday: Weekday, wakeUpTime: Date)
    
    // Delete
    func deleteStudiumObject(_ studiumEvent: StudiumEvent)
}
