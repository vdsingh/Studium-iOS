//
//  TimeChunkTests.swift
//  StudiumTests
//
//  Created by Vikram Singh on 10/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import XCTest
@testable import Studium

//class TimeChunk {
//    
//    //TODO: Docstrings
//    let startTime: Time
//    
//    //TODO: Docstrings
//    let endTime: Time
//    
//    /// Label what this TimeChunk represents (if applicable)
//    let descriptor: String?
//    
//    //TODO: Docstrings
//    var lengthInMinutes: Int {
////        let diffComponents = Calendar.current.dateComponents([.minute], from: startDate, to: endDate)
////        return diffComponents.minute ?? 0
//        return self.endTime.timeInMinutes - self.startTime.timeInMinutes
//    }
//    
//    //TODO: Docstrings
//    var midpoint: Time {
////        return startDate.addingTimeInterval(endDate.timeIntervalSince(startDate) / 2)
//        let midpointMinutes = self.lengthInMinutes / 2
//        return Time(timeInMinutes: midpointMinutes)
//    }
//    
//    //TODO: Docstrings
//    init(startTime: Time, endTime: Time, descriptor: String? = nil) {
//        self.startTime = startTime
//        self.endTime = endTime
//        self.descriptor = descriptor
//    }
//}


class TimeChunkTests: XCTestCase {
    
    func testLengthInMinutes() {
        let timeChunk1 = TimeChunk(startTime: .noon, endTime: .onePM)
        XCTAssertEqual(timeChunk1.lengthInMinutes, 60)
        
        let timeChunk2 = TimeChunk(startTime: Time(hour: 12, minute: 59),
                                  endTime: Time(hour: 13, minute: 0))
        XCTAssertEqual(timeChunk2.lengthInMinutes, 1)
    }
    
    func testMidpoint() {
        
    }
}
