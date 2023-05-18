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

import VikUtilityKit

protocol StudiumEventContainer {
    associatedtype ScheduledEventType: StudiumEvent
    
    //TODO: Docstrings
    var scheduledEvents: [ScheduledEventType] { get }

}

/// Protocol for StudiumEvents that can be autoscheduled
protocol Autoscheduleable: StudiumEvent, StudiumEventContainer {
    
    associatedtype EventType: StudiumEvent
    
    /// The amount of time (in minutes) that autoscheduled events should be scheduled for
    var autoLengthMinutes: Int { get set }
    
    /// Whether or not this event is in charge of autoscheduling other events
    var autoscheduling: Bool { get set }
    
    //TODO: Docstrings
    var autoscheduled: Bool { get set }
    
    //TODO: Docstrings
    func appendScheduledEvent(event: EventType)
}

/// Represents StudiumEvents that repeat
class RecurringStudiumEvent: StudiumEvent {
    
    /// Represents the days as ints for which this event occurs on
    internal var daysList = List<Int>()
    
    /// Represents the days for which this event occurs on
    var days: Set<Weekday> {
        get {
            return Set<Weekday>( daysList.compactMap { Weekday(rawValue: $0) })
        }
        
        set {
            let list = List<Int>()
            list.append(objectsIn: newValue.compactMap({ $0.rawValue }))
            self.daysList = list
        }
    }
    
    /// Whether or not the event occurs today
    var occursToday: Bool {
        return self.occursOn(date: Date())
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
    
    
    //TODO: Fix add to apple calendar
    
    ///Adds the event to Apple calendar
    ///Todo: make sure if the event is being edited, it overwrites the previous events in Apple Calendar.
    override func addToAppleCalendar(){
        let store = EKEventStore()
        let event = EKEvent(eventStore: store)
        
        let identifier = UserDefaults.standard.string(forKey: "appleCalendarID")
        if identifier == nil { //the user is not synced with Apple Calendar
            return
        }
        
        event.location = location
        event.calendar = store.calendar(withIdentifier: identifier!) ?? store.defaultCalendarForNewEvents
        event.title = name
        event.startDate = startDate
        event.endDate = endDate
        event.notes = additionalDetails
        
//        let daysDict: [Int: EKRecurrenceDayOfWeek] = [
//            2: EKRecurrenceDayOfWeek(EKWeekday.monday),
//            3: EKRecurrenceDayOfWeek(EKWeekday.tuesday),
//            4: EKRecurrenceDayOfWeek(EKWeekday.wednesday),
//            5: EKRecurrenceDayOfWeek(EKWeekday.thursday),
//            6: EKRecurrenceDayOfWeek(EKWeekday.friday),
//            7: EKRecurrenceDayOfWeek(EKWeekday.saturday),
//            1: EKRecurrenceDayOfWeek(EKWeekday.sunday)]
//        var newDays: [EKRecurrenceDayOfWeek] = []
//        for day in days {
//            newDays.append(daysDict[day]!)
//        }
//        event.addRecurrenceRule(EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: nil))
//        event.addRecurrenceRule(
//            EKRecurrenceRule(
//                recurrenceWith: .weekly,
//                interval: 1,
//                daysOfTheWeek: newDays,
//                daysOfTheMonth: nil,
//                monthsOfTheYear: nil,
//                weeksOfTheYear: nil,
//                daysOfTheYear: nil,
//                setPositions: nil,
//                end: nil
//            )
//        )

        do {
            try store.save(event, span: EKSpan.futureEvents, commit: true)
        } catch let error as NSError {
            print("$ERR: Failed to save event. Error: \(error)")
        }
    }
    
    
}

