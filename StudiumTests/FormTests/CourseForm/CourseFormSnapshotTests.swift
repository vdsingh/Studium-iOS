//
//  CourseFormSnapshotTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Studium

final class CourseFormSnapshotTests: XCTestCase {
    
    /// Snapshots the "Edit Course" form with a mock course
    func snapshotEditCourseForm() {
        let mockCourse = MockStudiumEventService.getMockCourse()
        let editCourseController = CourseFormViewController(course: mockCourse, refreshCallback: { })
        assertSnapshot(matching: editCourseController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: editCourseController, as: .image(on: .iPhoneSe))
    }
    
    /// Snapshots the "Add Course" form
    func snapshotAddCourseForm() {
        let addCourseController = CourseFormViewController(refreshCallback: { })
        assertSnapshot(matching: addCourseController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: addCourseController, as: .image(on: .iPhoneSe))
    }
}
