//
//  MockDatabaseService.swift
//  Studium
//
//  Created by Vikram Singh on 5/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class MockDatabaseService: DatabaseServiceProtocol {
    
    var user: User? = nil
    
    static let shared = MockDatabaseService()
    
    private init() { }
    
    var events = [StudiumEvent]()
    
    func saveStudiumObject(_ studiumEvent: StudiumEvent) {
        self.events.append(studiumEvent)
    }
    
    func saveAssignment(assignment: Assignment, parentCourse: Course) {
        parentCourse.appendAssignment(assignment)
        self.events.append(assignment)
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
    
    func getAssignments(forCourse course: Course) -> [Assignment] {
        return course.assignments
    }
    
    func getUserSettings() -> UserSettings {
        return UserSettings(weekdayCases: [])
    }
    
    func markComplete(_ completableEvent: CompletableStudiumEvent, _ complete: Bool) {
        completableEvent.complete = complete
    }
    
    func editStudiumEvent(oldEvent: StudiumEvent, newEvent: StudiumEvent) {
//        oldEvent
    }
    
    func setWakeUpTime(for weekday: Weekday, wakeUpTime: Date?) {
        
    }
    
    func deleteStudiumObject(_ studiumEvent: StudiumEvent) {
        self.events.removeAll(where: { $0 == studiumEvent })
    }
    
    func deleteAssignmentsForCourse(course: Course) {
//        course.assignments.remove
    }
}
