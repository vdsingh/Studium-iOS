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
    
    //TODO: Docstrings
    var mockDatabaseService: MockDatabaseService!
    
    //TODO: Docstrings
    var autoscheduleService: AutoscheduleService!
    
    //TODO: Docstrings
    var mockParentCourse: Course!
    
    //TODO: Docstrings
    var autoscheduleAssignment: Assignment!
    
    //TODO: Docstrings
    var nonAutoscheduleAssignment: Assignment!
    
    //TODO: Docstrings
    var mockAutoscheduleHabit: Habit!
    
    // TODO: Docstrings
    var mockNonAutoscheduleHabit: Habit!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.mockDatabaseService = MockDatabaseService.shared
        self.autoscheduleService = AutoscheduleService(databaseService: self.mockDatabaseService)
        
        var courseDays = Set<Weekday>()
        courseDays.insert(.tuesday)
        courseDays.insert(.thursday)
        self.mockParentCourse = Course(name: "Parent Course", color: .green, location: "", additionalDetails: "", startDate: Date(), endDate: Date() + 10000, days: courseDays, logo: .bolt, notificationAlertTimes: [], partitionKey: "")
        
        var autoDays = Set<Weekday>()
        autoDays.insert(.monday)
        autoDays.insert(.wednesday)
        self.autoscheduleAssignment = Assignment(name: "Autoschedule Assignment", additionalDetails: "", complete: false, startDate: Date(), endDate: Date() + 10000, notificationAlertTimes: [], autoschedule: true, autoLengthMinutes: 60, autoDays: autoDays, partitionKey: "", parentCourse: self.mockParentCourse)
        
        self.mockDatabaseService.saveAssignment(assignment: self.autoscheduleAssignment, parentCourse: self.mockParentCourse)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        self.mockParentCourse = nil
        self.autoscheduleAssignment = nil
        self.mockDatabaseService = nil
        self.autoscheduleService = nil
        self.mockParentCourse = nil
        self.autoscheduleAssignment = nil
        self.nonAutoscheduleAssignment = nil
        self.mockAutoscheduleHabit = nil
        self.mockNonAutoscheduleHabit = nil
    }

    
    func testAutoscheduleEvent() {
        // The start and end dates of the event should be mutated
        //
    }
    
    func testGetCommitments() {
        // Make sure it catches recurring events
        
        let date = Date.someTuesday
        
        let commitments = autoscheduleService.getCommitments(for: date)
        assert(commitments.count == 1)
        assert(commitments.first!.startDate.occursAtTheSameTimeAs(self.mockParentCourse.startDate))

    }
    
    func testGetOpenTimeSlots() {
        // Test startBound occurs after endBound
        // Test no commitments
    }
    
    func testBestTime() {
        
    }
    
    func testFindAutoscheduleTimeChunk() {
        
    }
    
    
    func testFindAllApplicableDatesBetween() {
        // Test start date occurs after end date

    }
    
    func testAutoscheduleStudyTime() {
        // Test parentAssignment.autoschedule = false
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
