//
//  OtherEventFormTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 9/28/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import XCTest
@testable import Studium
import SwiftUI

//TODO: Add tests for length of textfields
class OtherEventFormTests: XCTestCase {

    func testOtherEventProperties(otherEvent: OtherEvent, viewModel: OtherEventFormViewModel) {
        XCTAssertEqual(otherEvent.name, viewModel.name)
        XCTAssertEqual(otherEvent.location, viewModel.location)
        XCTAssertEqual(otherEvent.startDate, viewModel.startDate)
        XCTAssertEqual(otherEvent.endDate, viewModel.endDate)
        XCTAssertEqual(otherEvent.alertTimes, viewModel.notificationSelections)
        XCTAssertEqual(otherEvent.icon, viewModel.icon)
        XCTAssertEqual(otherEvent.color.hexValue(), viewModel.color?.hexValue())
        XCTAssertEqual(otherEvent.additionalDetails, viewModel.additionalDetails)
    }
    
    func testFormWithAllValid() throws {
        let viewModel = OtherEventFormViewModel.mockValid()
        
        let otherEvent = viewModel.constructOtherEvent()
        XCTAssertEqual(viewModel.formErrors, [])
        let unwrappedOtherEvent = try XCTUnwrap(otherEvent)
        self.testOtherEventProperties(otherEvent: unwrappedOtherEvent, viewModel: viewModel)
    }
    
    func testFormWithInvalidName() {
        let viewModel = OtherEventFormViewModel.mockValid()
        viewModel.name = ""
        
        let otherEvent = viewModel.constructOtherEvent()
        XCTAssertNil(otherEvent)
        XCTAssert(viewModel.formErrors.contains(StudiumFormError.nameNotSpecified))
        XCTAssert(viewModel.formErrors.count == 1)
    }
    
    func testFormWithInvalidEndTime() {
        let viewModel = OtherEventFormViewModel.mockValid()
        viewModel.endDate = viewModel.startDate.add(hours: -1)
        
        let otherEvent = viewModel.constructOtherEvent()
        XCTAssertNil(otherEvent)
        XCTAssert(viewModel.formErrors.contains(StudiumFormError.endTimeOccursBeforeStartTime))
        XCTAssert(viewModel.formErrors.count == 1)
    }
    
    func testFormWithInvalidColors() {
        let viewModel = OtherEventFormViewModel.mockValid()
        viewModel.color = nil
        
        let otherEvent = viewModel.constructOtherEvent()
        XCTAssertNil(otherEvent)
        XCTAssert(viewModel.formErrors.contains(StudiumFormError.colorNotSpecfied))
        XCTAssert(viewModel.formErrors.count == 1)
    }
}

extension OtherEventFormViewModel {
    static func mockValid() -> OtherEventFormViewModel {
        return OtherEventFormViewModel(name: "Name",
                                       location: "Location",
                                       startDate: Time.noon.arbitraryDateWithTime,
                                       endDate: (Time.noon + 60).arbitraryDateWithTime,
                                       notificationSelections: [.atTime, .fifteenMin],
                                       icon: .baseball,
                                       color: StudiumEventColor.darkRed.uiColor,
                                       additionalDetails: "Additional Details", completion: {})
    }
}
