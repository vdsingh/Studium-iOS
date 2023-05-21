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
    func saveStudiumObject(_ studiumEvent: StudiumEvent)
    func saveAssignment(assignment: Assignment, parentCourse: Course)
    func getStudiumObjects <T: StudiumEvent> (expecting type: T.Type) -> [T]
    func getAllStudiumObjects() -> [StudiumEvent]
    func getAssignments(forCourse course: Course) -> [Assignment]
    func getUserSettings() -> UserSettings
    func markComplete(_ completableEvent: CompletableStudiumEvent, _ complete: Bool)
    func editStudiumEvent(oldEvent: StudiumEvent, newEvent: StudiumEvent)
    func setWakeUpTime(for weekday: Weekday, wakeUpTime: Date)
    func deleteStudiumObject(_ studiumEvent: StudiumEvent)
    func setDefaultAlertOptions(alertOptions: [AlertOption])
    func getDefaultAlertOptions() -> [AlertOption]
}
