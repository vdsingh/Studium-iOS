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
struct Time: Comparable {
    let hour: Int
    let minute: Int
    
    var arbitraryDateWithTime: Date {
        return Date.distantPast.setTime(hour: self.hour, minute: self.minute, second: 0)
    }
    
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
    
    static var noon = Time(hour: 12, minute: 00)
    
    static var now = Time(hour: Date().hour, minute: Date().minute)
    
    static func inOneHour() -> Time {
        return Time(hour: Date().add(hours: 1).hour, minute: Date().minute)
    }
    
    func adding(hours: Int, minutes: Int) -> Time {
        return Time(hour: self.hour + hours, minute: self.minute + minutes)
    }
}
