//
//  EditCourseFormSnapshotTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Studium

final class EditCourseFormSnapshotTests: XCTestCase {
    
    /// Snapshots the "Edit Course" form with a mock course
    func testEditCourseForm() {
        let mockCourse = MockStudiumEventService.getMockCourse()
        let editCourseController = EditCourseViewController(course: mockCourse,
                                                            refreshCallback: { })
        assertSnapshot(matching: editCourseController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: editCourseController, as: .image(on: .iPhoneSe))
    }
    
    /// Snapshots the "Add Course" form
    func testAddCourseForm() {
        let view = AddCourseViewController(refreshCallback: {})
        assertSnapshot(matching: view, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: view, as: .image(on: .iPhoneSe))
    }
}
