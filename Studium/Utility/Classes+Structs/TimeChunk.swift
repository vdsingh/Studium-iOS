//
//  TimeChunk.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

/// Represents a chunk of Time
struct TimeChunk {
    
    //TODO: Docstrings
    let startTime: Time
    
    //TODO: Docstrings
    let endTime: Time
    
    //TODO: Docstrings
    let descriptor: String?
    
    //TODO: Docstrings
    var lengthInMinutes: Int {        
//        let diffComponents = Calendar.current.dateComponents([.minute], from: startDate, to: endDate)
//        return diffComponents.minute ?? 0
        return self.endTime.timeInMinutes - self.startTime.timeInMinutes
    }
    
    //TODO: Docstrings
    var midpoint: Time {
//        return startDate.addingTimeInterval(endDate.timeIntervalSince(startDate) / 2)
        let midpointMinutes = self.lengthInMinutes / 2
        return Time(timeInMinutes: midpointMinutes)
    }
    
    //TODO: Docstrings
    init(startTime: Time, endTime: Time, descriptor: String? = nil) {
        self.startTime = startTime
        self.endTime = endTime
        self.descriptor = descriptor
    }
}

extension TimeChunk: Equatable {
    static func == (lhs: TimeChunk, rhs: TimeChunk) -> Bool {
        lhs.startTime == rhs.startTime && lhs.endTime == rhs.endTime
    }
}

extension TimeChunk: CustomStringConvertible {
    var description: String {
        return "\(self.startTime) - \(self.endTime)"
    }
}
