//
//  StudiumTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 5/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import XCTest
@testable import Studium

//TODO: Docstrings
//final class AutoscheduleServiceTests: XCTestCase {
//    
//    // Monday: autoscheduleAssignment, nonAutoscheduleAssignment, mockAutoscheduleHabit, mockNonAutoscheduleHabit
//    
//    // Tuesday: mockParentCourse
//    
//    // Wednesday: mockAutoscheduleHabit, mockNonAutoscheduleHabit
//    
//    // Thursday: mockParentCourse
//    
//    //TODO: Docstrings
//    var mockDatabaseService = MockDatabaseService.shared
//    
//    //TODO: Docstrings
//    lazy var autoscheduleService: AutoscheduleService = {
//        AutoscheduleService(databaseService: self.mockDatabaseService)
//    }()
//    
//    // Occurs on Tuesday, Thursday
//    var mockParentCourse: Course!
//    
//    // Due on Date.someMonday
//    var autoscheduleAssignment: Assignment!
//    
//    // Due on Date.someMonday
//    var nonAutoscheduleAssignment: Assignment!
//    
//    // Occurs on Mondays and Wednesdays
//    var mockAutoscheduleHabit: Habit!
//    
//    // Occurs on Mondays and Wednesdays
//    var mockNonAutoscheduleHabit: Habit!
//    
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        
//        var tuesdayThursdayDays = Set<Weekday>()
//        tuesdayThursdayDays.insert(.tuesday)
//        tuesdayThursdayDays.insert(.thursday)
//        
//        var mondayWednesdayDays = Set<Weekday>()
//        mondayWednesdayDays.insert(.monday)
//        mondayWednesdayDays.insert(.wednesday)
//        
//        self.mockParentCourse = Course(name: "Parent Course", color: .green, location: "", additionalDetails: "", startDate: Date.someTuesday, endDate: Date.someTuesday.add(minutes: 60), days: tuesdayThursdayDays, logo: .bolt, notificationAlertTimes: [], partitionKey: "")
//        
//        self.autoscheduleAssignment = Assignment(name: "Autoschedule Assignment", additionalDetails: "", complete: false, startDate: Date.someMonday, endDate: Date.someMonday.add(minutes: 60), notificationAlertTimes: [], autoschedule: true, autoLengthMinutes: 60, autoDays: mondayWednesdayDays, partitionKey: "", parentCourse: self.mockParentCourse)
//        
//        self.nonAutoscheduleAssignment = Assignment(name: "Non-Autoschedule Assignment", additionalDetails: "", complete: false, startDate: Date.someMonday, endDate: Date.someMonday.add(minutes: 60), notificationAlertTimes: [], autoschedule: false, autoLengthMinutes: 60, autoDays: mondayWednesdayDays, partitionKey: "", parentCourse: self.mockParentCourse)
//        
//        self.mockAutoscheduleHabit = Habit(name: "Autoschedule Habit", location: "", additionalDetails: "", startDate: Date.someFriday, endDate: Date.someFriday.add(hours: 1), autoscheduling: false, startEarlier: true, autoLengthMinutes: 60, alertTimes: [], days: mondayWednesdayDays, logo: .a, color: .blue, partitionKey: "")
//        
//        //        self.mockAutoscheduleHabit = Habit(name: "Autoschedule Habit", location: "", additionalDetails: "", startDate: Date.someFriday, endDate: Date.someFriday.add(hours: 1), autoscheduling: true, startEarlier: true, autoLengthMinutes: 60, alertTimes: [], days: mondayWednesdayDays, logo: .a, color: .blue, partitionKey: "")
//        
//        self.mockNonAutoscheduleHabit = Habit(name: "Non-Autoschedule Habit", location: "", additionalDetails: "", startDate: Date.someFriday, endDate: Date.someFriday, autoscheduling: false, startEarlier: true, autoLengthMinutes: 60, alertTimes: [], days: mondayWednesdayDays, logo: .a, color: .blue, partitionKey: "")
//        
//        self.mockDatabaseService.saveStudiumObject(self.mockParentCourse)
//        self.mockDatabaseService.saveAssignment(assignment: self.autoscheduleAssignment, parentCourse: self.mockParentCourse)
//        self.mockDatabaseService.saveAssignment(assignment: self.nonAutoscheduleAssignment, parentCourse: self.mockParentCourse)
//        //        self.mockDatabaseService.saveStudiumObject(self.mockAutoscheduleHabit)
//        //        self.mockDatabaseService.saveStudiumObject(self.mockNonAutoscheduleHabit)
//    }
//    
//    override func tearDownWithError() throws {
//        // Services
//        self.mockDatabaseService.removeAllStudiumEvents()
//        
//        // Objects
//        self.autoscheduleAssignment = nil
//        self.mockParentCourse = nil
//        self.autoscheduleAssignment = nil
//        self.nonAutoscheduleAssignment = nil
//        self.mockAutoscheduleHabit = nil
//        self.mockNonAutoscheduleHabit = nil
//    }
//    
//    //TODO: Docstrings
//    func testAutoscheduleEvent() {
//        // The start and end dates of the event should be mutated
//        //
//    }
//    
//    /// Make sure that getting commitments for a given day works properly
//    func testGetCommitments() {
//        // Catch Recurring Events
//        
//        // There should be 1 commitment on Date.someTuesday, which is our mock course.
//        commitmentTests(Date.someTuesday, 1, [self.mockParentCourse])
//        
//        // There should be 1 commit on a random Tuesday, which is our mock course.
//        commitmentTests(Date.random(weekday: .tuesday), 1, [self.mockParentCourse])
//        
//        // There should be 1 commitment on Date.someWednesday, which is our non-auto habit.
//        commitmentTests(Date.someWednesday, 1, [self.mockNonAutoscheduleHabit])
//        
//        // There should be 1 commitments on a random Wednesday, which is our non-auto habit.
//        commitmentTests(Date.random(weekday: .wednesday), 1, [self.mockNonAutoscheduleHabit])
//        
//        // There should be 3 commitments on Date.someMonday, which are the auto/non-auto assignments, and the non-auto habit
//        commitmentTests(Date.someMonday, 3, [self.autoscheduleAssignment, self.nonAutoscheduleAssignment, self.mockNonAutoscheduleHabit])
//        
//        // There should be 1 commitment on a random Monday, which is non-auto habit
//        commitmentTests(Date.random(weekday: .monday), 1, [self.mockNonAutoscheduleHabit])
//        
//        // There should be no commitments on Friday.
//        commitmentTests(Date.someFriday, 0, [])
//        commitmentTests(Date.random(weekday: .friday), 0, [])
//        
//        
//        // This function just runs the tests for each case
//        func commitmentTests(
//            _ desiredDate: Date,
//            _ desiredCount: Int,
//            _ expectedEvents: [StudiumEvent]
//        ) {
//            let commitments = self.autoscheduleService.getCommitments(for: desiredDate)
//            for event in expectedEvents {
//                assert(event.occursOn(date: desiredDate), "The event \(event.name) does not occur on \(desiredDate)")
//                
//                // Make sure that the event is a commitment on the date
//                if let commitmentTimeChunk = commitments[event] {
//                    let eventTimeChunk = event.timeChunkForDate(date: desiredDate)
//                    assert(eventTimeChunk?.startDate == commitmentTimeChunk.startDate, "time chunk mismatch: expected event \(event.name) time chunk start date to be \(String(describing: eventTimeChunk?.startDate)) but it was \(commitmentTimeChunk.startDate). The desired date is \(desiredDate)")
//                    assert(eventTimeChunk?.endDate == commitmentTimeChunk.endDate)
//                    
//                } else {
//                    assertionFailure("Expected event \(event.name) to be a commitment for date \(desiredDate), but it did not appear as a key.")
//                }
//            }
//            
//            assert(commitments.count == desiredCount, "expected commitments count to be \(desiredCount), but was actually \(commitments.count). The commitments are named: \(commitments.keys.map({ $0.name }))")
//        }
//    }
//    
//    // Monday: autoscheduleAssignment, nonAutoscheduleAssignment, mockAutoscheduleHabit, mockNonAutoscheduleHabit
//    
//    // Tuesday: mockParentCourse
//    
//    // Wednesday: mockAutoscheduleHabit, mockNonAutoscheduleHabit
//    
//    // Thursday: mockParentCourse
//    
//    //TODO: Docstrings
//    func testGetOpenTimeSlots() {
//        //        var mondaySet = Set<Weekday>()
//        //        mondaySet.insert(.monday)
//        //        let course = Course(name: "Mock Course", color: .black, location: "", additionalDetails: "", startDate: Date.someMonday.setTime(hour: 8, minute: 0, second: 0)!, endDate: Date.someMonday.setTime(hour: 9, minute: 0, second: 0)!, days: mondaySet, logo: .a, notificationAlertTimes: [], partitionKey: "")
//        //        self.mockDatabaseService.saveStudiumObject(course)
//        //
//        //        let someMondayCommitments = self.autoscheduleService.getCommitments(for: Date.someMonday)
//        //        let openTimeSlots = self.autoscheduleService.getOpenTimeSlots(startBound: Date.someMonday.setTime(hour: 8, minute: 0, second: 0)!, endBound: Date.someMonday.setTime(hour: 10, minute: 0, second: 0)!, commitments: [TimeChunk](someMondayCommitments.values))
//        //
//        //        assert(openTimeSlots.count == 1)
//        //        openTimeSlots.first
//        
//        // Test startBound occurs after endBound
//        // Test no commitments
//    }
//    
//    //TODO: Docstrings
//    func testBestTime() {
//        
//    }
//    
//    //TODO: Docstrings
//    func testFindAutoscheduleTimeChunk() {
//        
//    }
//    
//    //TODO: Docstrings
//    func testFindAllApplicableDatesBetween() {
//        
//        // Test start date occurs after end date
//        var applicableDates = self.autoscheduleService.findAllApplicableDatesBetween(startDate: Date.someFriday, endDate: Date.someMonday, weekdays: Set<Weekday>())
//        assert(applicableDates.count == 0)
//        
//        // Find Wednesday between Monday and Friday
//        var weekdays = Set<Weekday>()
//        weekdays.insert(.wednesday)
//        applicableDates = self.autoscheduleService.findAllApplicableDatesBetween(startDate: Date.someMonday, endDate: Date.someFriday, weekdays: weekdays)
//        assert(applicableDates.count == 1, "Expected one applicable date but found \(applicableDates.count). Applicable Dates: \(applicableDates)")
//        
//        if let date = applicableDates.first {
//            assert(date.occursOn(date: Date.someWednesday))
//        } else {
//            assertionFailure("Expected there to be at least one applicable date, but first returned nil.")
//        }
//        
//        // Monday -> Monday -> Monday
//        applicableDates = self.autoscheduleService.findAllApplicableDatesBetween(startDate: Date.someMonday, endDate: Date.someMonday.add(days: 14), weekdays: weekdays)
//        assert(applicableDates.count == 2, "Expected two applicable dates but found \(applicableDates.count). Applicable Dates: \(applicableDates)")
//        assert(applicableDates.first!.occursOn(date: Date.someWednesday))
//        assert(applicableDates[1].occursOn(date: Date.someWednesday.add(days: 7)))
//        
//    }
//    
//    //TODO: Docstrings
//    func testAutoscheduleStudyTime() {
//        // Test parentAssignment.autoschedule = false
//    }
//    
//    //TODO: Docstrings
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
//    
//}
