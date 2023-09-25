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
    func testEditHabitForm() {
        let mockHabit = MockStudiumEventService.mockHabit
        let editHabitViewController = EditHabitViewController(habit: mockHabit,
                                                              refreshCallback: { })
        assertSnapshot(matching: editHabitViewController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: editHabitViewController, as: .image(on: .iPhoneSe))
    }
    
    /// Snapshots the "Add Habit" form with a mock habit
    func testEmptyAddHabitForm() {
        let view = AddHabitViewController(refreshCallback: {})
        assertSnapshot(matching: view, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: view, as: .image(on: .iPhoneSe))
    }
}
