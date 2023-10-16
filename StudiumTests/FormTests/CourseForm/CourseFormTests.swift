//
//  AddCourseTests.swift
//  Studium
//
//  Created by Vikram Singh on 9/23/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import XCTest
@testable import Studium
import SwiftUI

class CourseFormTests: XCTestCase {

    var viewModel: CourseFormViewModel = .mockValid()

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        self.viewModel = CourseFormViewModel.mockValid()
    }

    // MARK: - Helpers

    private func testCourseProperties(course: Course, viewModel: CourseFormViewModel) {
        XCTAssertEqual(course.name, viewModel.name)
        XCTAssertEqual(course.location, viewModel.location)
        XCTAssertEqual(course.days, viewModel.daysSelected)
        XCTAssertEqual(course.startDate.time, viewModel.startTime)
        XCTAssertEqual(course.endDate.time, viewModel.endTime)
        XCTAssertEqual(course.alertTimes, viewModel.notificationSelections)
        XCTAssertEqual(course.icon, viewModel.icon)
        XCTAssertEqual(course.color.hexValue(), viewModel.color?.hexValue())
        XCTAssertEqual(course.additionalDetails, viewModel.additionalDetails)
    }

    // MARK: - All Valid Fields

    func testFormWithAllValid() throws {
        let course = self.viewModel.constructCourse()
        XCTAssertEqual(self.viewModel.formErrors, [])
        let unwrappedCourse = try XCTUnwrap(course)
        self.testCourseProperties(course: unwrappedCourse, viewModel: viewModel)
    }

    // MARK: - Test Invalid Fields

    func testFormWithInvalidName() {
        self.viewModel.name = ""

        let course = self.viewModel.constructCourse()
        XCTAssertNil(course)
        XCTAssert(self.viewModel.formErrors.contains(StudiumFormError.nameNotSpecified))
        XCTAssert(self.viewModel.formErrors.count == 1)
    }

    func testFormWithInvalidDaysSelected() {
        self.viewModel.daysSelected = []

        let course = self.viewModel.constructCourse()
        XCTAssertNil(course)
        XCTAssert(self.viewModel.formErrors.contains(StudiumFormError.oneDayNotSpecified))
        XCTAssert(self.viewModel.formErrors.count == 1)
    }

    func testFormWithInvalidEndTime() {
        self.viewModel.endTime = self.viewModel.startTime-60

        let course = self.viewModel.constructCourse()
        XCTAssertNil(course)
        XCTAssert(self.viewModel.formErrors.contains(StudiumFormError.endTimeOccursBeforeStartTime))
        XCTAssert(self.viewModel.formErrors.count == 1)
    }

    func testFormWithInvalidColors() {
        self.viewModel.color = nil

        let course = self.viewModel.constructCourse()
        XCTAssertNil(course)
        XCTAssert(self.viewModel.formErrors.contains(StudiumFormError.colorNotSpecfied))
        XCTAssert(self.viewModel.formErrors.count == 1)
    }
}

extension CourseFormViewModel {

    /// Creates a CourseFormViewModel with all valid fields (no form errors)
    /// - Returns: a CourseFormViewModel with all valid fields (no form errors)
    static func mockValid() -> CourseFormViewModel {
        return CourseFormViewModel(name: "Name", location: "Location", daysSelected: [.tuesday, .thursday], startTime: .noon, endTime: .noon+60, notificationSelections: [.atTime, .fifteenMin], icon: .baseball, color: StudiumEventColor.darkRed.uiColor, additionalDetails: "Additional Details", willComplete: {})
    }
}
