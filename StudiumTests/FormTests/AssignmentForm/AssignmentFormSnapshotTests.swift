//
//  AssignmentFormSnapshotTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 10/5/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
@testable import Studium
import XCTest
import SnapshotTesting

final class AssignmentFormSnapshotTests: XCTestCase {

    let mockCourse = Course.mock()

    /// Snapshots the "Edit Assignment" form with a mock non autoscheduling Assignment
    func snapshotFullAssignmentFormNonAuto() {
        let mockAssignment = Assignment.mock(parentCourse: self.mockCourse, autoscheduling: false)
        let editAssignmentController = AssignmentFormViewController(
            course: self.mockCourse,
            assignment: mockAssignment,
            refreshCallback: { }
        )
        assertSnapshot(matching: editAssignmentController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: editAssignmentController, as: .image(on: .iPhoneSe))
    }

    /// Snapshots the "Edit Assignment" form with a mock autoscheduling Assignment
    func snapshotFullAssignmentFormAuto() {
        let mockAssignment = Assignment.mock(parentCourse: self.mockCourse, autoscheduling: true)
        let editAssignmentController = AssignmentFormViewController(
            course: self.mockCourse,
            assignment: mockAssignment,
            refreshCallback: { }
        )
        assertSnapshot(matching: editAssignmentController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: editAssignmentController, as: .image(on: .iPhoneSe))
    }

    /// Snapshots the "Add Assignment" form
    func snapshotEmptyAssignmentForm() {
        let addAssignmentController = AssignmentFormViewController(
            course: self.mockCourse,
            refreshCallback: { }
        )
        assertSnapshot(matching: addAssignmentController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: addAssignmentController, as: .image(on: .iPhoneSe))
    }
}
