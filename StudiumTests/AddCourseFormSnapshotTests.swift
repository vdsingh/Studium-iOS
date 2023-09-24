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

final class AddCourseFormSnapshotTests: XCTestCase {
    func testEmptyAddCourseForm() {
        let view = AddCourseViewController(refreshCallback: {})
        assertSnapshot(matching: view, as: .image(on: .iPhoneXsMax))
        assertSnapshot(matching: view, as: .image(on: .iPhoneSe))
    }
}
