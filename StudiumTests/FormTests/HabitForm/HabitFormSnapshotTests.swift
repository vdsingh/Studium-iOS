//
//  EditHabitSnapshotTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Studium

final class HabitFormSnapshotTests: XCTestCase {

    /// Snapshots the "Edit Habit" form with a mock habit
    func snapshotEditHabitForm() {
        let mockHabit = MockStudiumEventService.mockHabit
        let editHabitViewController = HabitFormViewController(habit: mockHabit,
                                                              refreshCallback: { })
        assertSnapshot(matching: editHabitViewController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: editHabitViewController, as: .image(on: .iPhoneSe))
    }

    /// Snapshots the "Add Habit" form with a mock habit
    func snapshotEmptyAddHabitForm() {
        let view = HabitFormViewController(refreshCallback: {})
        assertSnapshot(matching: view, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: view, as: .image(on: .iPhoneSe))
    }
}
