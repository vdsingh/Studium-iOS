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
//import XCTest

//class CourseFormTests: XCTestCase {
//
//    // Mock bindings and other necessary properties
//     var formErrors: [StudiumFormError] = []
//    
//     var invalidCourseName: String = ""
//     var validCourseName: String = "Course Name"
//
//     var location: String = ""
//    
//     var invalidDaysSelected: Set<Weekday> = []
//     var validDaysSelected: Set<Weekday> = [.monday, .friday]
//
//     var startDate: Date = Date().setTime(hour: 12, minute: 0, second: 0)!
//    
//     var invalidEndDate: Date = Date().setTime(hour: 12, minute: 0, second: 0)!.add(hours: -1)
//     var validEndDate: Date = Date().setTime(hour: 12, minute: 0, second: 0)!.add(hours: 1)
//
//     var notificationSelections: [AlertOption] = [.oneHour, .fifteenMin]
//    
//     var icon: StudiumIcon = .atom
//    
//     var validColor: UIColor? = StudiumEventColor.darkRed.uiColor
//     var invalidColor: UIColor? = nil
//    
//     var additionalDetails: String = "Additional Details"
//
//    func testFormWithAllValid() {
//        // Create an instance of CourseFormView with valid data
//        let view = CourseFormView(
//            formErrors: self.$formErrors, name: self.$validCourseName,
//            location: $location, daysSelected: self.$validDaysSelected,
//            startDate: self.$startDate, endDate: self.$validEndDate,
//            notificationSelections: self.$notificationSelections,
//            icon: self.$icon, color: self.$validColor,
//            additionalDetails: self.$additionalDetails
//        )
//
//        let course = view.createdCourse()
//        XCTAssertNotNil(course)
//    }
//    
//    func testFormWithInvalidName() {
//        // Create an instance of CourseFormView with valid data
//        let view = CourseFormView(
//            formErrors: self.$formErrors, name: self.$invalidCourseName,
//            location: $location, daysSelected: self.$validDaysSelected,
//            startDate: self.$startDate, endDate: self.$validEndDate,
//            notificationSelections: self.$notificationSelections,
//            icon: self.$icon, color: self.$validColor,
//            additionalDetails: self.$additionalDetails
//        )
//
//        let course = view.createdCourse()
//        XCTAssertNil(course)
//        XCTAssert(self.formErrors.contains(StudiumFormError.nameNotSpecified))
//    }
//}
