//
//  TimeTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 9/28/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import XCTest
@testable import Studium

class TimeTests: XCTestCase {
    
    let onePM = Time(hour: 13, minute: 0)
    let oneThirtyPM = Time(hour: 13, minute: 30)
    
    // MARK: - Test Constructors

    func testTimeInMinutesConstructor() {
        let onePMFromMinutesConstructor = Time(timeInMinutes: 13 * 60)
        XCTAssertEqual(self.onePM, onePMFromMinutesConstructor)
        
        let oneThirtyPMFromMinutesConstructor = Time(timeInMinutes: 60 * 13 + 30)
        XCTAssertEqual(oneThirtyPMFromMinutesConstructor, oneThirtyPM)
    }
    
    // MARK: - Computed Properties

    func testArbitraryDateWithTime() {
        let onePMArbitraryDateWithTime = self.onePM.arbitraryDateWithTime
        
        XCTAssertEqual(onePMArbitraryDateWithTime.hour, self.onePM.hour)
        XCTAssertEqual(onePMArbitraryDateWithTime.minute, self.onePM.minute)
    }
    
    func testTimeInMinutes() {
        XCTAssertEqual(self.onePM.timeInMinutes, 60 * 13)
        XCTAssertEqual(self.oneThirtyPM.timeInMinutes, 60 * 13 + 30)
    }
    
    // MARK: - Comparable + Custom Operators
    
    func testPlusOperator() {
        let oneOone = self.onePM + 1
        XCTAssertEqual(oneOone, Time(hour: 13, minute: 1))
        
        let two = self.onePM + 60
        XCTAssertEqual(two, Time(hour: 14, minute: 0))
        
        let oneFiftyNinePM = Time(hour: 13, minute: 59)
        let twoPM = oneFiftyNinePM + 1
        XCTAssertEqual(twoPM, Time(hour: 14, minute: 0))
    }
    
    func testMinusOperator() {
        let subtractedOneMinute = self.onePM - 1
        XCTAssertEqual(subtractedOneMinute, Time(hour: 12, minute: 59))
        
        let oneTwentyNine = self.oneThirtyPM - 1
        XCTAssertEqual(oneTwentyNine, Time(hour: 13, minute: 29))
    }
    
    func testComparable() {
        let eightAM = Time(hour: 8, minute: 0)
        let eightThirtyAM = Time(hour: 8, minute: 30)
        let eightPM = Time(hour: 16, minute: 0)
        let eightThirtyPM = Time(hour: 16, minute: 30)
        
        XCTAssertTrue(eightAM < eightThirtyAM)
        XCTAssertTrue(eightThirtyAM < eightPM)
        XCTAssertTrue(eightPM < eightThirtyPM)
    }
}
