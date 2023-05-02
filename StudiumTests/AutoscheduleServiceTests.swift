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
final class AutoscheduleServiceTests: XCTestCase {
    
    // Monday: autoscheduleAssignment, nonAutoscheduleAssignment, mockAutoscheduleHabit, mockNonAutoscheduleHabit
    
    // Tuesday: mockParentCourse
    
    // Wednesday: mockAutoscheduleHabit, mockNonAutoscheduleHabit
    
    // Thursday: mockParentCourse
    
    //TODO: Docstrings
    var mockDatabaseService: MockDatabaseService!
    
    //TODO: Docstrings
    var autoscheduleService: AutoscheduleService!
    
    // Occurs on Tuesday, Thursday
    var mockParentCourse: Course!
    
    // Due on Date.someMonday
    var autoscheduleAssignment: Assignment!
    
    // Due on Date.someMonday
    var nonAutoscheduleAssignment: Assignment!
    
    // Occurs on Mondays and Wednesdays
    var mockAutoscheduleHabit: Habit!
    
    // Occurs on Mondays and Wednesdays
    var mockNonAutoscheduleHabit: Habit!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.mockDatabaseService = MockDatabaseService.shared
        self.autoscheduleService = AutoscheduleService(databaseService: self.mockDatabaseService)
        
        var tuesdayThursdayDays = Set<Weekday>()
        tuesdayThursdayDays.insert(.tuesday)
        tuesdayThursdayDays.insert(.thursday)
        
        var mondayWednesdayDays = Set<Weekday>()
        mondayWednesdayDays.insert(.monday)
        mondayWednesdayDays.insert(.wednesday)
        
        self.mockParentCourse = Course(name: "Parent Course", color: .green, location: "", additionalDetails: "", startDate: Date.someTuesday, endDate: Date.someTuesday.add(minutes: 60), days: tuesdayThursdayDays, logo: .bolt, notificationAlertTimes: [], partitionKey: "")
        

        self.autoscheduleAssignment = Assignment(name: "Autoschedule Assignment", additionalDetails: "", complete: false, startDate: Date.someMonday, endDate: Date.someMonday.add(minutes: 60), notificationAlertTimes: [], autoschedule: true, autoLengthMinutes: 60, autoDays: mondayWednesdayDays, partitionKey: "", parentCourse: self.mockParentCourse)
        
        self.nonAutoscheduleAssignment = Assignment(name: "Non-Autoschedule Assignment", additionalDetails: "", complete: false, startDate: Date.someMonday, endDate: Date.someMonday.add(minutes: 60), notificationAlertTimes: [], autoschedule: false, autoLengthMinutes: 60, autoDays: mondayWednesdayDays, partitionKey: "", parentCourse: self.mockParentCourse)
        
        self.mockAutoscheduleHabit = Habit(name: "Autoschedule Habit", location: "", additionalDetails: "", startDate: Date.someFriday, endDate: Date.someFriday, autoschedule: true, startEarlier: true, autoLengthMinutes: 60, alertTimes: [], days: mondayWednesdayDays, logo: .a, color: .blue, partitionKey: "")
        
        self.mockNonAutoscheduleHabit = Habit(name: "Autoschedule Habit", location: "", additionalDetails: "", startDate: Date.someFriday, endDate: Date.someFriday, autoschedule: false, startEarlier: true, autoLengthMinutes: 60, alertTimes: [], days: mondayWednesdayDays, logo: .a, color: .blue, partitionKey: "")
        
        self.mockDatabaseService.saveStudiumObject(self.mockParentCourse)
        self.mockDatabaseService.saveAssignment(assignment: self.autoscheduleAssignment, parentCourse: self.mockParentCourse)
        self.mockDatabaseService.saveAssignment(assignment: self.nonAutoscheduleAssignment, parentCourse: self.mockParentCourse)
        self.mockDatabaseService.saveStudiumObject(self.mockAutoscheduleHabit)
        self.mockDatabaseService.saveStudiumObject(self.mockNonAutoscheduleHabit)
    }

    override func tearDownWithError() throws {
        // Services
        self.autoscheduleService = nil
        self.mockDatabaseService = nil
        
        // Objects
        self.autoscheduleAssignment = nil
        self.mockParentCourse = nil
        self.autoscheduleAssignment = nil
        self.nonAutoscheduleAssignment = nil
        self.mockAutoscheduleHabit = nil
        self.mockNonAutoscheduleHabit = nil
    }

    //TODO: Docstrings
    func testAutoscheduleEvent() {
        // The start and end dates of the event should be mutated
        //
    }
    
    
    // Monday: autoscheduleAssignment, nonAutoscheduleAssignment, mockAutoscheduleHabit (R), mockNonAutoscheduleHabit (R)
    
    // Tuesday: mockParentCourse (R)
    
    // Wednesday: mockAutoscheduleHabit (R), mockNonAutoscheduleHabit (R)
    
    // Thursday: mockParentCourse (R)
    
    //TODO: Docstrings
    func testGetCommitments() {
        // Catch Recurring Events
        
        // There should be 1 commitment on Date.someTuesday, which is our mock course.
        commitmentTests(Date.someTuesday, 1, [self.mockParentCourse])

        // There should be 1 commit on a random Tuesday, which is our mock course.
        commitmentTests(Date.random(weekday: .tuesday), 1, [self.mockParentCourse])

        // There should be 1 commitment on Date.someWednesday, which is our non-auto habit.
        commitmentTests(Date.someWednesday, 1, [self.mockNonAutoscheduleHabit])
        
        // There should be 1 commitments on a random Wednesday, which is our non-auto habit.
        commitmentTests(Date.random(weekday: .wednesday), 1, [self.mockNonAutoscheduleHabit])
        
        // There should be 3 commitments on Date.someMonday, which are the auto/non-auto assignments, and the non-auto habit
        commitmentTests(Date.random(weekday: .tuesday), 3, [self.autoscheduleAssignment, self.nonAutoscheduleAssignment, self.mockNonAutoscheduleHabit])

        // There should be 1 commitment on a random Monday, which is non-auto habit
        commitmentTests(Date.random(weekday: .monday), 1, [self.mockNonAutoscheduleHabit])
        
        // There should be no commitments on Friday.
        commitmentTests(Date.someFriday, 0, [])
        commitmentTests(Date.random(weekday: .friday), 0, [])
        
        
        // This function just runs the tests for each case
        func commitmentTests(
            _ desiredDate: Date,
            _ desiredCount: Int,
            _ expectedEvents: [StudiumEvent]
        ) {
            let commitments = self.autoscheduleService.getCommitments(for: desiredDate)
            for event in expectedEvents {
                assert(event.occursOn(date: desiredDate), "The event \(event) does not occur on \(desiredDate)")
                
                // Make sure that the event is a commitment on the date
                if let commitmentTimeChunk = commitments[event] {
                    let eventTimeChunk = event.timeChunkForDate(date: desiredDate)
                    assert(eventTimeChunk?.startDate == commitmentTimeChunk.startDate, "time chunk mismatch: expected event \(event.name) time chunk start date to be \(String(describing: eventTimeChunk?.startDate)) but it was \(commitmentTimeChunk.startDate). The desired date is \(desiredDate)")
                    assert(eventTimeChunk?.endDate == commitmentTimeChunk.endDate)
                    
                } else {
                    assertionFailure("Expected event \(event.name) to be a commitment for date \(desiredDate), but it did not appear as a key.")
                }
            }
            
            assert(commitments.count == desiredCount, "expected commitments count to be \(desiredCount), but was actually \(commitments.count). The commitments are named: \(commitments.keys.map({ $0.name }))")
        }
    }
    
    //TODO: Docstrings
    func testGetOpenTimeSlots() {
        
        let someMondayCommitments = self.autoscheduleService.getCommitments(for: Date.someTuesday)
        let openTimeSlots = self.autoscheduleService.getOpenTimeSlots(startBound: Date.someTuesday.startOfDay, endBound: Date.someMonday.endOfDay, commitments: [])
        
        
        
        // Test startBound occurs after endBound
        // Test no commitments
    }
    
    //TODO: Docstrings
    func testBestTime() {
        
    }
    
    //TODO: Docstrings
    func testFindAutoscheduleTimeChunk() {
        
    }
    
    //TODO: Docstrings
    func testFindAllApplicableDatesBetween() {
        // Test start date occurs after end date

    }
    
    //TODO: Docstrings
    func testAutoscheduleStudyTime() {
        // Test parentAssignment.autoschedule = false
    }

    //TODO: Docstrings
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
