//
//  MockCourse.swift
//  Studium
//
//  Created by Vikram Singh on 8/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
struct MockStudiumEventService {
    private init() { }
    
    static func getMockCourse() -> Course {
        return self.calculusII
    }
    
    static func getMockCourses() -> [Course] {
        return [self.calculusII, self.bioLab, self.worldHistory, self.economics, self.compsci]
    }
    
    static var mockHabits: [Habit] {
        return [self.habit_gym, self.habit_read]
    }
    
    static var mockHabit: Habit {
        return self.habit_gym
    }
    
    static var mockAutoschedulingHabit: Habit {
        return self.habit_read
    }
    
    static let calculusII = Course(name: "Calculus II", color: StudiumEventColor.blue.uiColor, location: "Math Center Room 123", additionalDetails: "These are the additional details", startDate: Time.noon.arbitraryDateWithTime, endDate: Time.noon.arbitraryDateWithTime, days: [.monday, .wednesday, .friday], icon: .function, notificationAlertTimes: [.atTime, .fifteenMin, .oneHour])
    static let calculusIIAssignment1 = Assignment(name: "Homework 1", additionalDetails: "", complete: false, startDate: Date(), endDate: Date(), notificationAlertTimes: [], autoschedulingConfig: nil, parentCourse: MockStudiumEventService.calculusII)

    static let bioLab = Course(name: "Biology Lab", color: StudiumEventColor.green.uiColor, location: "Biology Lab Room 246", additionalDetails: "", startDate: Date(), endDate: Date(), days: [.tuesday, .thursday], icon: .function, notificationAlertTimes: [])

    static let worldHistory = Course(name: "World History", color: StudiumEventColor.yellow.uiColor, location: "History Building Room 135", additionalDetails: "", startDate: Date(), endDate: Date(), days: [.monday, .wednesday], icon: .function, notificationAlertTimes: [])

    static let economics = Course(name: "Economics 101", color: StudiumEventColor.green.uiColor, location: "Econ Center Room 369", additionalDetails: "", startDate: Date(), endDate: Date(), days: [.monday, .wednesday, .friday], icon: .function, notificationAlertTimes: [])

    static let compsci = Course(name: "Computer Science 230", color: StudiumEventColor.purple.uiColor, location: "Computer Science Building Room 404", additionalDetails: "", startDate: Date(), endDate: Date(), days: [.wednesday, .friday], icon: .function, notificationAlertTimes: [])
    
    
    static let habit_gym = Habit(name: "Go to the Gym", location: "123 Lightweight Road", additionalDetails: "", startDate: Date(), endDate: Date(), autoschedulingConfig: nil, alertTimes: [], days: [.monday, .tuesday, .thursday], icon: .dumbbell, color: StudiumEventColor.red.uiColor)
    static let habit_read = Habit(name: "Read a book", location: "Bed", additionalDetails: "", startDate: Date(), endDate: Date(), autoschedulingConfig: AutoschedulingConfig(autoLengthMinutes: 60, autoscheduleInfinitely: true, useDatesAsBounds: true, autoschedulingDays: [.wednesday, .friday]), alertTimes: [], days: [.wednesday, .friday], icon: .book, color: StudiumEventColor.green.uiColor)
}
