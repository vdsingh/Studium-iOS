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

//final class OtherEventFormSnapshotTests: XCTestCase {
//    
//    /// Snapshots the "Edit Habit" form with a mock habit
//    func testEditOtherEventForm() {
//        let mockOtherEvent = OtherEvent.mock()
//        let editOtherEventViewController = EditOtherEventViewController(otherEvent: mockOtherEvent, refreshCallback: { })
//        
////        EditHabitViewController(habit: mockHabit,
////                                                              refreshCallback: { })
//        assertSnapshot(matching: editOtherEventViewController, as: .image(on: .iPhoneXsMax))
//        assertSnapshot(matching: editOtherEventViewController, as: .image(on: .iPhoneSe))
//    }
//    
//    /// Snapshots the "Add Habit" form with a mock habit
//    func testEmptyAddOtherEventForm() {
//        let view = AddHabitViewController(refreshCallback: {})
//        assertSnapshot(matching: view, as: .image(on: .iPhoneXsMax))
//        assertSnapshot(matching: view, as: .image(on: .iPhoneSe))
//    }
//}
//
//extension OtherEvent {
//    static func mock() -> OtherEvent {
//        return OtherEvent(name: "Other Event", location: "Location", additionalDetails: "Additional Details", startDate: Date.distantPast, endDate: Date.distantPast.add(hours: 2), color: StudiumEventColor.green, icon: .book, alertTimes: [.fifteenMin, .oneDay])
//    }
//}
