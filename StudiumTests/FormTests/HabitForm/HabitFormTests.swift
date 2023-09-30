//
//  HabitFormTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 9/28/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import XCTest
@testable import Studium
import SwiftUI

class HabitFormTests: XCTestCase {
    
    var addViewModel: HabitFormViewModel = .mockValid()
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        self.addViewModel = HabitFormViewModel.mockValid()
    }
    
        // Helper to compare properties a habit to a fields of form view model
    private func testHabitProperties(habit: Habit, viewModel: HabitFormViewModel) {
        XCTAssertEqual(habit.name, viewModel.name)
        XCTAssertEqual(habit.location, viewModel.location)
        XCTAssertEqual(habit.days, viewModel.daysSelected)
        XCTAssertEqual(habit.autoscheduling, viewModel.isAutoscheduling)
        XCTAssertEqual(habit.startDate.time, viewModel.startTime)
        XCTAssertEqual(habit.endDate.time, viewModel.endTime)
        XCTAssertEqual(habit.alertTimes, viewModel.notificationSelections)
        XCTAssertEqual(habit.icon, viewModel.icon)
        XCTAssertEqual(habit.color.hexValue(), viewModel.color?.hexValue())
        XCTAssertEqual(habit.additionalDetails, viewModel.additionalDetails)
    }
}

// MARK: - Edit Habit Form Tests

extension HabitFormTests {
    
    /// Constructed Habit should be the same as original Habit if there are no changes
    func testEditHabitWithoutChanges() throws {
        var mockHabit = Habit.mock(autoscheduling: true)
        var editViewModel = HabitFormViewModel(habit: mockHabit, willComplete: {})
        var constructedHabit = try XCTUnwrap(editViewModel.constructHabit())
        // Without any changes, the original habit should be the same as the constructed
        XCTAssertTrue(mockHabit.isEqualWithoutId(to: constructedHabit))
        
        mockHabit = Habit.mock(autoscheduling: false)
        editViewModel = HabitFormViewModel(habit: mockHabit, willComplete: {})
        constructedHabit = try XCTUnwrap(editViewModel.constructHabit())
        // Without any changes, the original habit should be the same as the constructed
        XCTAssertTrue(mockHabit.isEqualWithoutId(to: constructedHabit))
    }
}

// MARK: - Add Habit Form Tests

extension HabitFormTests {
    
    // MARK: - All Valid Fields

    func testFormWithAllValid() throws {
        let habit = self.addViewModel.constructHabit()
        XCTAssertEqual(self.addViewModel.formErrors, [])
        let unwrappedHabit = try XCTUnwrap(habit)
        self.testHabitProperties(habit: unwrappedHabit, viewModel: self.addViewModel)
    }
    
    // MARK: - Test Invalid Fields
    
    func testFormWithInvalidAutoLength() {
        self.addViewModel.isAutoscheduling = true
        self.addViewModel.totalAutoscheduleLengthMinutes = 0
        
        let habit = self.addViewModel.constructHabit()
        XCTAssertNil(habit)
        XCTAssert(self.addViewModel.formErrors.contains(StudiumFormError.totalTimeNotSpecified))
        XCTAssert(self.addViewModel.formErrors.count == 1)
    }
    
    func testTotalTimeExceedsTimeFrame() {
        self.addViewModel.isAutoscheduling = true
        self.addViewModel.totalAutoscheduleLengthMinutes = 120
        self.addViewModel.startTime = .noon
        self.addViewModel.endTime = .noon.adding(hours: 1, minutes: 0)
        
        let habit = self.addViewModel.constructHabit()
        XCTAssertNil(habit)
        XCTAssert(self.addViewModel.formErrors.contains(StudiumFormError.totalTimeExceedsTimeFrame))
        XCTAssert(self.addViewModel.formErrors.count == 1)
    }
    
    func testFormWithInvalidName() {
        self.addViewModel.name = ""
        
        let habit = self.addViewModel.constructHabit()
        XCTAssertNil(habit)
        XCTAssert(self.addViewModel.formErrors.contains(StudiumFormError.nameNotSpecified))
        XCTAssert(self.addViewModel.formErrors.count == 1)
    }
    
    func testFormWithInvalidDaysSelected() {
        self.addViewModel.daysSelected = []
        
        let habit = self.addViewModel.constructHabit()
        XCTAssertNil(habit)
        XCTAssert(self.addViewModel.formErrors.contains(StudiumFormError.oneDayNotSpecified))
        XCTAssert(self.addViewModel.formErrors.count == 1)
    }
    
    func testFormWithInvalidEndTime() {
        self.addViewModel.endTime = self.addViewModel.startTime.adding(hours: -1, minutes: 0)
        
        let habit = self.addViewModel.constructHabit()
        XCTAssertNil(habit)
        XCTAssert(self.addViewModel.formErrors.contains(StudiumFormError.endTimeOccursBeforeStartTime))
        XCTAssert(self.addViewModel.formErrors.count == 1)
    }
    
    func testFormWithInvalidColors() {
        self.addViewModel.color = nil
        
        let habit = self.addViewModel.constructHabit()
        XCTAssertNil(habit)
        XCTAssert(self.addViewModel.formErrors.contains(StudiumFormError.colorNotSpecfied))
        XCTAssert(self.addViewModel.formErrors.count == 1)
    }
}

extension HabitFormViewModel {
    
    /// Creates a HabitFormViewModel with all valid fields (no form errors)
    /// - Returns: a HabitFormViewModel with all valid fields (no form errors)
    static func mockValid() -> HabitFormViewModel {
        return HabitFormViewModel(name: "Mock Habit", location: "Mock Location", daysSelected: [.monday, .wednesday], isAutoscheduling: false, totalAutoLengthMinutes: 0, startTime: .noon, endTime: .noon.adding(hours: 1, minutes: 0), notificationSelections: [.fiveMin, .fifteenMin], icon: .bath, color: StudiumEventColor.lightGreen.uiColor, additionalDetails: "Mock Additional Details", willComplete: {})
    }
}
