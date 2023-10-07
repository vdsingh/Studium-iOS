//
//  StudiumTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 5/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import XCTest
@testable import Studium

final class AutoscheduleServiceTests: XCTestCase {
    
    var autoscheduleService = AutoscheduleService.shared
    
    // MARK: - findOpenTimeSlots Tests
    
    /// Test  commitment 1 is completely within commitment 2
    func testFindOpenTimeSlots_completelyContainedCommitment() {
        let commitments: [TimeChunk] = [TimeChunk(startTime: .nineAM, endTime: .elevenAM),
                                        TimeChunk(startTime: .nineAM+30, endTime: .tenAM+30)]
        
        // No time slots at all
        var timeSlots = self.testFindOpenTimeSlotsHelper(commitments: commitments, endTime: .elevenAM)
        XCTAssertEqual(timeSlots, [])

        // No time slots long enough
        timeSlots = self.testFindOpenTimeSlotsHelper(commitments: commitments, endTime: .elevenAM+30)
        XCTAssertEqual(timeSlots, [])
        
        // One time slot available
        timeSlots = self.testFindOpenTimeSlotsHelper(commitments: commitments, endTime: .noon)
        XCTAssertEqual(timeSlots, [TimeChunk(startTime: .elevenAM, endTime: .noon)])
    }
    
    /// Test commitment 1 starts before commitment 2 but they both end at the same time
    func testFindOpenTimeSlots_differentStartSameEnd() {
        let commitments: [TimeChunk] = [TimeChunk(startTime: .nineAM, endTime: .elevenAM),
                                        TimeChunk(startTime: .nineAM+30, endTime: .elevenAM)]
        
        // No time slots at all
        var timeSlots = self.testFindOpenTimeSlotsHelper(commitments: commitments, endTime: .elevenAM)
        XCTAssertEqual(timeSlots, [])

        // No time slots long enough
        timeSlots = self.testFindOpenTimeSlotsHelper(commitments: commitments, endTime: .elevenAM+30)
        XCTAssertEqual(timeSlots, [])
        
        // One time slot available
        timeSlots = self.testFindOpenTimeSlotsHelper(commitments: commitments, endTime: .noon)
        XCTAssertEqual(timeSlots, [TimeChunk(startTime: .elevenAM, endTime: .noon)])
    }

    /// Test commitment 1 starts before commitment 2 but they both end at the same time
    func testFindOpenTimeSlots_differentStartDifferentEnd() {
        let commitments: [TimeChunk] = [TimeChunk(startTime: .nineAM, endTime: .tenAM+30),
                                        TimeChunk(startTime: .tenAM, endTime: .elevenAM)]
        // No time slots at all
        var timeSlots = self.testFindOpenTimeSlotsHelper(commitments: commitments, endTime: .elevenAM)
        XCTAssertEqual(timeSlots, [])

        // No time slots long enough
        timeSlots = self.testFindOpenTimeSlotsHelper(commitments: commitments, endTime: .elevenAM+30)
        XCTAssertEqual(timeSlots, [])
        
        // One time slot available
        timeSlots = self.testFindOpenTimeSlotsHelper(commitments: commitments, endTime: .noon)
        XCTAssertEqual(timeSlots, [TimeChunk(startTime: .elevenAM, endTime: .noon)])
    }
    
    func testFindOpenTimeSlotsHelper(commitments: [TimeChunk], endTime: Time) -> [TimeChunk] {
        self.autoscheduleService.findOpenTimeSlots(commitments: commitments, startTimeBound: .nineAM,
                                                   endTimeBound: endTime, minLengthMinutes: 60)
    }
    
    /// No commitments, should return a single open time slot for the entire day.
    func testFindOpenTimeSlots_noCommitments() {
        let startTime = Time(hour: 8, minute: 0)
        let endTime = Time(hour: 17, minute: 0)
        
        let commitments: [TimeChunk] = []
        let openTimeSlots = self.autoscheduleService.findOpenTimeSlots(commitments: commitments,
                                                                        startTimeBound: startTime,
                                                                        endTimeBound: endTime,
                                                                        minLengthMinutes: 60)
        XCTAssertEqual(openTimeSlots.count, 1)
        XCTAssertEqual(openTimeSlots.first?.startTime, startTime)
        XCTAssertEqual(openTimeSlots.first?.endTime, endTime)
    }
    
    /// One commitment completely overlaps the start and end bounds
    func testFindOpenTimeSlots_commitmentOverlapsBounds() {
        let startTime = Time(hour: 8, minute: 0)
        let endTime = Time(hour: 17, minute: 0)
        
        let commitments: [TimeChunk] = [TimeChunk(startTime: Time(hour: 7, minute: 0), endTime: Time(hour: 18, minute: 0))]
        let openTimeSlots = self.autoscheduleService.findOpenTimeSlots(commitments: commitments,
                                                                       startTimeBound: startTime,
                                                                       endTimeBound: endTime,
                                                                       minLengthMinutes: 60)
        XCTAssertEqual(openTimeSlots, [])
    }
    
    /// Realistic example of finding open time slots
    func testFindOpenTimeSlots_realisticScenario() {
        let startTime = Time(hour: 8, minute: 0) // 8 AM
        let endTime = Time(hour: 17, minute: 0) //  5 PM
        
        let commitments = [
            TimeChunk(startTime: Time(hour: 7, minute: 0), endTime: Time(hour: 8, minute: 30)),   // 7 AM to 8:30 AM
            TimeChunk(startTime: Time(hour: 9, minute: 0), endTime: Time(hour: 10, minute: 30)),  // 9 AM to 10:30 AM
            TimeChunk(startTime: Time(hour: 12, minute: 0), endTime: Time(hour: 13, minute: 0)),  // 12 PM to 1 PM
            TimeChunk(startTime: Time(hour: 14, minute: 0), endTime: Time(hour: 15, minute: 30)), // 2 PM to 3:30 PM
            TimeChunk(startTime: Time(hour: 4, minute: 30), endTime: Time(hour: 6, minute: 0))    // 5:30 PM to 6:00 PM
        ]
        
        // Gaps: 8:30AM to 9 AM, 10:30 AM to 12 PM, 1PM to 2PM, 3:30 PM to 5 PM
        let openTimeSlots = self.autoscheduleService.findOpenTimeSlots(commitments: commitments,
                                                                        startTimeBound: startTime,
                                                                        endTimeBound: endTime,
                                                                        minLengthMinutes: 30)
        
        XCTAssertEqual(openTimeSlots, [
            TimeChunk(startTime: Time(hour: 8, minute: 30), endTime: Time(hour: 9, minute: 0)),
            TimeChunk(startTime: Time(hour: 10, minute: 30), endTime: Time(hour: 12, minute: 0)),
            TimeChunk(startTime: Time(hour: 13, minute: 0), endTime: Time(hour: 14, minute: 0)),
            TimeChunk(startTime: Time(hour: 15, minute: 30), endTime: Time(hour: 17, minute: 0)),
        ])
    }
    
    /// No open time slots, all day is booked.
    func testFindOpenTimeSlots_noTimeSlotsAvailable() {
        let startTime = Time(hour: 8, minute: 0)
        let endTime = Time(hour: 17, minute: 0)
        
        let commitments3 = [
            TimeChunk(startTime: Time(hour: 8, minute: 0), endTime: Time(hour: 17, minute: 0)), // 8AM - 5PM
        ]
        let openTimeSlots3 = self.autoscheduleService.findOpenTimeSlots(commitments: commitments3,
                                                                        startTimeBound: startTime,
                                                                        endTimeBound: endTime,
                                                                        minLengthMinutes: 60)
        XCTAssertEqual(openTimeSlots3.count, 0)
    }
    
    /// Commitments that exactly match start and end times.
    func testFindOpenTimeSlots_commitmentsMatchBounds() {
        let startTime = Time(hour: 8, minute: 0)
        let endTime = Time(hour: 17, minute: 0)
        
        let commitments = [
            TimeChunk(startTime: startTime, endTime: Time(hour: 9, minute: 0)),
            TimeChunk(startTime: Time(hour: 15, minute: 0), endTime: endTime),
        ]
        let openTimeSlots = self.autoscheduleService.findOpenTimeSlots(commitments: commitments, 
                                                                       startTimeBound: startTime,
                                                                       endTimeBound: endTime,
                                                                       minLengthMinutes: 60)
        XCTAssertEqual(openTimeSlots.count, 1)
        XCTAssertEqual(openTimeSlots[0].startTime, Time(hour: 9, minute: 0))
        XCTAssertEqual(openTimeSlots[0].endTime, Time(hour: 15, minute: 0))
    }
    
    // MARK: - findAllApplicableDatesBetween Tests
    
    // TODO: test for start date after end date
    // TODO: tset for start date = end date with that day specified
    
    func testFindAllApplicableDatesBetween_normalInputs() {
        let startDate = Date.someMonday
        let endDate = Date.someMonday.add(weeks: 1)
        
        let weekdays: Set<Weekday> = [.monday]
        let resultDates = self.autoscheduleService.findAllApplicableDatesBetween(startDate: startDate,
                                                                                 endDate: endDate,
                                                                                 weekdays: weekdays)
        XCTAssertEqual(resultDates.count, 2)
    }
    
    func testFindAllApplicableDatesBetween_startDateAfterEndDate() {
        let startDate = Date.someMonday
        let endDate = Date.someMonday.add(weeks: -1)
        
        let weekdays: Set<Weekday> = [.monday]
        let resultDates1 = self.autoscheduleService.findAllApplicableDatesBetween(startDate: startDate,
                                                                                  endDate: endDate,
                                                                                  weekdays: weekdays)
        XCTAssertEqual(resultDates1.count, 0)
    }
    
    func testFindAllApplicableDatesBetween_noDaysSpecified() {
        let startDate = Date.someMonday
        let endDate = Date.someMonday.add(weeks: 10)
        
        let weekdays: Set<Weekday> = []
        let resultDates1 = self.autoscheduleService.findAllApplicableDatesBetween(startDate: startDate,
                                                                                  endDate: endDate,
                                                                                  weekdays: weekdays)
        XCTAssertEqual(resultDates1.count, 0)
    }
    
    // MARK: - findAutoschedulingTimeSlots Tests
    
    // TODO: start date bound occurring after end date bound
    // TODO: start time bound occurring after end time bound
    // TODO:
    
    func testFindAutoschedulingTimeSlots() {
        let calendar = Calendar.current
        
        // Define some test configuration
        let startDateBound = Date.someMonday.endOfDay
        let endDateBound = Date.someMonday.add(days: 7).endOfDay
        let autoschedulingDays: Set<Weekday> = [.monday]
        let startTimeBound = Time(hour: 9, minute: 0)
        let endTimeBound = Time(hour: 17, minute: 0)
        let autoLengthMinutes = 60
        
        let autoschedulingConfig = AutoschedulingConfig(autoLengthMinutes: autoLengthMinutes,
                                                        startDateBound: startDateBound,
                                                        endDateBound: endDateBound,
                                                        startTimeBound: startTimeBound,
                                                        endTimeBound: endTimeBound,
                                                        autoschedulingDays: autoschedulingDays)
        
        // Test the function with the mock object.
        let expectation = self.expectation(description: "Time slots found")
        self.autoscheduleService.findAutoschedulingTimeSlots(forConfig: autoschedulingConfig) { timeSlots in
            XCTAssertEqual(timeSlots.count, 2)
            // There should be 5 weekdays between the dates, and each should have a time slot.
            // You can perform additional assertions on the time slots if needed.
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil) // Adjust the timeout as needed.
    }
        
        // Add more test cases as needed to cover various scenarios.
}

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
