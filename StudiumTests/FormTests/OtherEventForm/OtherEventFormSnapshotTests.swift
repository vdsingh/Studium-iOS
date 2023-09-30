//
//  OtherEventFormSnapshotTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 9/28/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SnapshotTesting
import XCTest
@testable import Studium

final class OtherEventFormSnapshotTests: XCTestCase {
    
    /// Snapshots the "Edit Habit" form with a mock habit
    func snapshotEditOtherEventForm() {
        let mockOtherEvent = OtherEvent.mock()
        let editOtherEventViewController = HabitFormViewController(otherEvent: mockOtherEvent, refreshCallback: { })
        assertSnapshot(matching: editOtherEventViewController, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: editOtherEventViewController, as: .image(on: .iPhoneSe))
    }
    
    /// Snapshots the "Add Habit" form with a mock habit
    func snapshotAddOtherEventForm() {
        let view = HabitFormViewController(refreshCallback: {})
        assertSnapshot(matching: view, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: view, as: .image(on: .iPhoneSe))
    }
}
