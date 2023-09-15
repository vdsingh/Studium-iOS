//
//  RecurringStudiumEvent.swift
//  Studium
//
//  Created by Vikram Singh on 5/19/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import Foundation
import EventKit
import CalendarKit
import RealmSwift

/// Represents StudiumEvents that repeat
class RecurringStudiumEvent: StudiumEvent, GoogleCalendarRecurringEventLinking {
    
    /// Represents the days as ints for which this event occurs on
    internal let daysList = List<Int>()
    
    /// Represents the days for which this event occurs on
    var days: Set<Weekday> {
        get {
            return Set<Weekday>( self.daysList.compactMap { Weekday(rawValue: $0) })
        }
        
        set {
            self.daysList.removeAll()
            self.daysList.append(objectsIn: newValue.compactMap({ $0.rawValue }))
        }
    }
    
    /// Whether or not the event occurs today
    var occursToday: Bool {
        return self.occursOn(date: Date())
    }
    
    var nextOccuringTimeChunk: TimeChunk? {
        if self.days.isEmpty {
            return nil
        }
        
        var currentDay = Date()
        
        // 1000 iteration limit
        for _ in 0..<1000 {
            if self.occursOn(date: currentDay) {
                return self.timeChunkForDate(date: currentDay)
            }
            
            currentDay = currentDay.add(days: 1)
        }
        
        return nil
    }
    
    var ekRecurrenceRule: EKRecurrenceRule {
        var daysOfTheWeek = [EKRecurrenceDayOfWeek]()
        
        // Create an array of EKRecurrenceDayOfWeek based on recurring event days
        for day in self.days {
            if let ekWeekday = EKWeekday(rawValue: day.rawValue) {
                daysOfTheWeek.append(EKRecurrenceDayOfWeek(ekWeekday))
            } else {
                Log.s(AppleCalendarServiceError.failedToCreateWeekdayFromRawValue, additionalDetails: "Tried to create an EKWeekday from rawValue: \(day.rawValue) but failed.")
            }
        }
        
        return EKRecurrenceRule(
            recurrenceWith: .weekly,
            interval: 1,
            daysOfTheWeek: daysOfTheWeek,
            daysOfTheMonth: nil,
            monthsOfTheYear: nil,
            weeksOfTheYear: nil,
            daysOfTheYear: nil,
            setPositions: nil,
            end: nil
        )
    }
    
    /// Whether or not the event occurs on a given date
    /// - Parameter date: The date that we're checking
    /// - Returns: Whether or not the event occurs on the date
    override func occursOn(date: Date) -> Bool {
        return self.days.contains(date.weekdayValue)
    }
    
    /// Returns a TimeChunk for this event on a given date
    /// - Parameter date: The date for which we want the TimeChunk
    /// - Returns: a TimeChunk for this event on a given date
    override func timeChunkForDate(date: Date) -> TimeChunk? {
        // This event doesn't occur on the date. return nil.
        if !self.occursOn(date: date) {
            return nil
        }
        
        let startDate = Calendar.current.date(bySettingHour: self.startDate.hour, minute: self.startDate.minute, second: 0, of: date)!
        let endDate = Calendar.current.date(bySettingHour: self.endDate.hour, minute: self.endDate.minute, second: 0, of: date)!
        return TimeChunk(startDate: startDate, endDate: endDate)
    }
}

