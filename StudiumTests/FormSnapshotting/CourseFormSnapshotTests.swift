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
    func testEditCourseForm() {
        let mockCourse = MockStudiumEventService.getMockCourse()
        let editCourseController = EditCourseViewController(course: mockCourse,
                                                            refreshCallback: { })
        assertSnapshot(matching: editCourseController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: editCourseController, as: .image(on: .iPhoneSe))
    }
}
