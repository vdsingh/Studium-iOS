//
//  DateTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 5/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import XCTest
@testable import Studium

// TODO: Docstrings
// final class DateTests: XCTestCase {
//    
//    //TODO: Docstrings
//    var mockCourse: Course!
//    
//    //TODO: Docstrings
//    var mockCourseInconsistentDatesAndDays: Course!
//    
//    //TODO: Docstrings
//    var defaultAssignment: Assignment!
//    
//    //TODO: Docstrings
//    var autoschedulingAssignment: Assignment!
//    
//    //TODO: Docstrings
//    var autoscheduledAssignment: Assignment!
//    
//    //TODO: Docstrings
//    var nonAutoHabit: Habit!
//    
//    //TODO: Docstrings
//    var autoHabit: Habit!
//    
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        
//        var mondayDays = Set<Weekday>()
//        mondayDays.insert(.monday)
//        
//        var monWedDays = Set<Weekday>()
//        monWedDays.insert(.monday)
//        monWedDays.insert(.wednesday)
//        
//        self.mockCourse = Course(name: "Mock Course", color: .blue, location: "", additionalDetails: "", startDate: Date.someMonday, endDate: Date.someMonday.add(minutes: 60), days: mondayDays, logo: .a, notificationAlertTimes: [], partitionKey: "")
//        
//        // The start and end dates are on a Tuesday, however the days set contains Monday
//        self.mockCourseInconsistentDatesAndDays = Course(name: "Mock Course Inconsistent", color: .blue, location: "", additionalDetails: "", startDate: Date.someTuesday, endDate: Date.someTuesday.add(minutes: 60), days: mondayDays, logo: .a, notificationAlertTimes: [], partitionKey: "")
//        
//        self.defaultAssignment = Assignment(name: "Default Assignment", additionalDetails: "", complete: false, startDate: Date.someMonday, endDate: Date.someMonday.add(hours: 1), notificationAlertTimes: [], autoschedule: false, autoLengthMinutes: 0, autoDays: Set<Weekday>(), partitionKey: "", parentCourse: self.mockCourse)
//        
//        self.autoschedulingAssignment = Assignment(name: "Autoscheduling Assignment", additionalDetails: "", complete: false, startDate: Date.someMonday, endDate: Date.someMonday.add(hours: 1), notificationAlertTimes: [], autoschedule: true, autoLengthMinutes: 60, autoDays: monWedDays, partitionKey: "", parentCourse: self.mockCourse)
//        
//        self.autoscheduledAssignment = Assignment(parentAssignment: self.autoschedulingAssignment)
//        
//        self.nonAutoHabit = Habit(name: "Non Auto Habit", location: "", additionalDetails: "", startDate: Date.someMonday, endDate: Date.someMonday.add(hours: 1), autoscheduling: false, startEarlier: false, autoLengthMinutes: 0, alertTimes: [], days: monWedDays, logo: .a, color: .gray, partitionKey: "")
//        
//        self.autoHabit = Habit(name: "Auto Habit", location: "", additionalDetails: "", startDate: Date.someMonday, endDate: Date.someMonday.add(hours: 1), autoscheduling: true, startEarlier: false, autoLengthMinutes: 60, alertTimes: [], days: monWedDays, logo: .a, color: .black, partitionKey: "")
//        
//    }
//    
//    //TODO: Docstrings
//    func testRandomDates() {
//        let randomSunday = Date.random(weekday: .sunday)
//        assert(randomSunday.weekday == 1)
//        assert(randomSunday.studiumWeekday == .sunday)
//        
//        let randomMonday = Date.random(weekday: .monday)
//        assert(randomMonday.weekday == 2)
//        assert(randomMonday.studiumWeekday == .monday)
//    }
//    
//    //TODO: Docstrings
//    func testOccursOn() {
//        let randomSunday = Date.random(weekday: .sunday)
//        let randomMonday = Date.random(weekday: .monday)
//        let randomTuesday = Date.random(weekday: .tuesday)
//        
//        // Mock Course
//        runTests(self.mockCourse, [Date.someMonday, randomMonday], [Date.someSunday, Date.someTuesday, randomSunday, randomTuesday])
//        
//        
//        // Mock Course where days set is not consistent with startDate and endDate (start/end Dates shouldn't matter)
//        runTests(self.mockCourseInconsistentDatesAndDays, [Date.someMonday, randomMonday], [Date.someSunday, Date.someTuesday, randomSunday, randomTuesday])
//        
//        // Default Assignment due Date.someMonday
//        self.defaultAssignment.setDates(startDate: Date.someMonday, endDate: Date.someMonday.add(hours: 1))
//        runTests(
//            self.defaultAssignment,
//            [Date.someMonday],
//            [Date.random(weekday: .monday), Date.someTuesday, Date.random(weekday: .tuesday)]
//        )
//        
//        // Autoscheduling Assignment due Date.someMonday
//        self.autoschedulingAssignment.setDates(startDate: Date.someMonday, endDate: Date.someMonday.add(hours: 1))
//        runTests(
//            self.defaultAssignment,
//            [Date.someMonday],
//            [Date.random(weekday: .monday), Date.someTuesday, Date.random(weekday: .tuesday)]
//        )
//        
//        // Autoscheduled Assignment due Date.someMonday
//        self.autoscheduledAssignment.setDates(startDate: Date.someMonday, endDate: Date.someMonday.add(hours: 1))
//        runTests(
//            self.autoscheduledAssignment,
//            [Date.someMonday],
//            [Date.random(weekday: .monday), Date.someTuesday, Date.random(weekday: .tuesday)]
//        )
//        
//        // Non Auto Habit (occurs Mon, Wed)
//        runTests(
//            self.nonAutoHabit,
//            [Date.someMonday, Date.someWednesday, Date.random(weekday: .monday), Date.random(weekday: .wednesday)],
//            [Date.someSunday, Date.someTuesday, Date.someThursday, Date.someFriday, Date.random(weekday: .sunday), Date.random(weekday: .tuesday), Date.random(weekday: .thursday), Date.random(weekday: .friday)]
//        )
//        
//        
//        // Auto Habit
//        runTests(
//            self.autoHabit,
//            [],
//            []
//        )
//        
//        func runTests(_ event: StudiumEvent, _ acceptingDates: [Date], _ rejectingDates: [Date]) {
//            for date in acceptingDates {
//                assert(event.occursOn(date: date), "event \(event.name) should occur on date \(date), but doesn't.")
//            }
//            
//            for date in rejectingDates {
//                assert(!event.occursOn(date: date), "event \(event.name) shouldn't occur on date \(date), but does.")
//            }
//        }
//    }
//    
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        self.mockCourse = nil
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//
// }
