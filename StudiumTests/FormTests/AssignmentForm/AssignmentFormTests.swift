//
//  AssignmentFormTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 10/5/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import XCTest
@testable import Studium
import SwiftUI

class AssignmentFormTests: XCTestCase {
    
//    var editingViewModel: AssignmentFormViewModel = AssignmentFormViewModel.mockValidEditViewModel()
    var addingViewModel: AssignmentFormViewModel = AssignmentFormViewModel.mockValidAddViewModel()
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
//        self.editingViewModel = AssignmentFormViewModel.mockValidEditViewModel()
        self.addingViewModel = AssignmentFormViewModel.mockValidAddViewModel()
    }
    
    // MARK: - Test Equatable
    
    /// Constructed Assignment should be the same as original Assignment if there are no changes
    func testEditAssignmentWithoutChanges() throws {
        // Autoscheduling
        var editViewModel = AssignmentFormViewModel
            .mockValidEditViewModel(withAssignment: .mock(autoscheduling: true))
        var constructedAssignment = try XCTUnwrap(editViewModel.constructAssignment())
        XCTAssertEqual(editViewModel.originalAssignment, constructedAssignment)
        
        // Non-Autoscheduling
        editViewModel = AssignmentFormViewModel
            .mockValidEditViewModel(withAssignment: .mock(autoscheduling: false))
        constructedAssignment = try XCTUnwrap(editViewModel.constructAssignment())
        XCTAssertEqual(editViewModel.originalAssignment, constructedAssignment)
    }
    
    // MARK: - Test Form Errors
    
    func testFormWithAllValid() throws {
        // IF all fields are valid
        let assignment = self.addingViewModel.constructAssignment()
        
        // THEN formErrors should be empty, and an Assignment should be created
        XCTAssertEqual(self.addingViewModel.formErrors, [])
        XCTAssertNotNil(assignment)
    }
    
    func testFormWithInvalidName() {
        // IF name is empty
        self.addingViewModel.name = ""
        let assignment = self.addingViewModel.constructAssignment()
        
        // THEN assignment should be nil with nameNotSpecified error
        XCTAssertNil(assignment)
        XCTAssert(self.addingViewModel.formErrors.contains(StudiumFormError.nameNotSpecified))
        XCTAssert(self.addingViewModel.formErrors.count == 1)
    }

    func testFormWithInvalidEndDate() {
        // IF endDate occurs before startDate
        self.addingViewModel.endDate = self.addingViewModel.startDate.subtract(minutes: 1)
        let assignment = self.addingViewModel.constructAssignment()
        
        // THEN assignment should be nil, formErrors should only have endDateOccursBeforeStartDate
        XCTAssertNil(assignment)
        XCTAssert(self.addingViewModel.formErrors.contains(StudiumFormError.endDateOccursBeforeStartDate))
        XCTAssert(self.addingViewModel.formErrors.count == 1)
    }
        
    func testFormWithInvalidAutoDays() {
        self.addingViewModel.isAutoscheduling = true
        self.addingViewModel.autoscheduleDays = []
        self.addingViewModel.totalAutoscheduleLengthMinutes = 60
        
        let assignment = self.addingViewModel.constructAssignment()
        
        XCTAssertNil(assignment)
        XCTAssertEqual(self.addingViewModel.formErrors, [.oneDayNotSpecified])
    }

    
    func testFormWithInvalidTotalAutoMinutes() {
        self.addingViewModel.isAutoscheduling = true
        self.addingViewModel.autoscheduleDays = [.monday]
        self.addingViewModel.totalAutoscheduleLengthMinutes = 0
        
        let assignment = self.addingViewModel.constructAssignment()
        
        XCTAssertNil(assignment)
        XCTAssertEqual(self.addingViewModel.formErrors, [.totalTimeNotSpecified])
    }
}

extension AssignmentFormViewModel {
    
    /// Creates a AssignmentFormViewModel intended to add with all valid fields (no form errors)
    /// - Returns: a AssignmentFormViewModel with all valid fields (no form errors)
    static func mockValidAddViewModel() -> AssignmentFormViewModel {
        return AssignmentFormViewModel(course: Course.mock(), name: "Mock Assignment", location: "Mock Location", isAutoscheduling: false, totalAutoLengthMinutes: 60, autoscheduleDays: [], startDate: Date.someMonday, endDate: Date.someMonday.add(hours: 1), notificationSelections: [.oneDay, .fifteenMin], additionalDetails: "Mock Additional Details", willComplete: {})
    }
    
    // TODO: Docstrings
    static func mockValidEditViewModel(withAssignment assignment: Assignment) -> AssignmentFormViewModel {
        let mockCourse = Course.mock()
        return AssignmentFormViewModel(
            assignment: assignment,
            willComplete: {}
        )
    }
}
