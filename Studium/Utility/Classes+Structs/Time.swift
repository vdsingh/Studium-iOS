//
//  Time.swift
//  Studium
//
//  Created by Vikram Singh on 9/27/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

// FIXME: Build in some mechanism to prevent invalid time (ex: 25 hours or 61 mins)

/// Represents a specific Time (day, month, year are irrelevant)
struct Time: Codable {
    
    let hour: Int
    let minute: Int
    
    /// Hour * 60 + minute
    var timeInMinutes: Int {
        return (self.hour * 60) + minute
    }
    
    /// An arbitrary date with this time
    var arbitraryDateWithTime: Date {
        return Date.distantPast.setTime(hour: self.hour, minute: self.minute, second: 0)
    }
    
    init(hour: Int, minute: Int) {
        self.hour = hour
        self.minute = minute
    }
    
    init(timeInMinutes: Int) {
        self.init(hour: timeInMinutes / 60, minute: timeInMinutes % 60)
    }
}

extension Time: CustomStringConvertible {
    var description: String {
        return "\(self.hour):\(self.minute)"
    }
}

// MARK: - Static Times
extension Time {
    
    // MARK: - Static Times
    static var startOfDay = Time(hour: 0, minute: 0)
    static var nineAM = Time(hour: 9, minute: 0)
    static var tenAM = Time(hour: 10, minute: 0)
    static let elevenAM = Time(hour: 11, minute: 0)
    static var noon = Time(hour: 12, minute: 0)
    static var onePM = Time(hour: 13, minute: 0)
    static var twoPM = Time(hour: 14, minute: 0)
    static var threePM = Time(hour: 15, minute: 0)
    static var fourPM = Time(hour: 16, minute: 0)
    static var fivePM = Time(hour: 17, minute: 0)
    static var sixPM = Time(hour: 18, minute: 0)
    static var sevenPM = Time(hour: 19, minute: 0)
    static var eightPM = Time(hour: 20, minute: 0)
    static var endOfDay = Time(hour: 23, minute: 59)

    
    // MARK: - Depends on Current Time
    static var now = Time(hour: Date().hour, minute: Date().minute)
    static func inOneHour() -> Time {
        return Time(hour: Date().add(hours: 1).hour, minute: Date().minute)
    }
}

// MARK: - Custom Operators

extension Time: Comparable {
    static func < (lhs: Time, rhs: Time) -> Bool {
        if lhs.hour < rhs.hour {
            return true
        } else if lhs.hour == rhs.hour {
            if lhs.minute < rhs.minute {
                return true
            }
        }
        
        return false
    }
    
    static func + (left: Time, right: Int) -> Time {
        let totalTimeInMinutes = left.timeInMinutes + right
        return Time(timeInMinutes: totalTimeInMinutes)
    }
    
    static func - (left: Time, right: Int) -> Time {
        let totalTimeInMinutes = left.timeInMinutes - right
        return Time(timeInMinutes: totalTimeInMinutes)
    }
}
