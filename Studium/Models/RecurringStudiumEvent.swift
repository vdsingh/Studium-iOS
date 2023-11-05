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

class NonRecurringStudiumEvent: StudiumEvent, GoogleCalendarEventLinking {

    /// The start date of the event
    @Persisted var startDate: Date = Date()

    /// The end date of the event
    @Persisted var endDate: Date = Date()

    /// Whether the event is complete
    @Persisted var complete: Bool = false

    /// Sets the start and end dates for the event
    /// - Parameters:
    ///   - startDate: The start date of the event
    ///   - endDate: The end date of the event
    func setDates(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

/// Represents StudiumEvents that repeat
class RecurringStudiumEvent: StudiumEvent {

    @Persisted private var startTimeCoded: Int = 0

    @Persisted private var endTimeCoded: Int = 0

    /// The start time of the event
    var startTime: Time {
        get { Time(timeInMinutes: self.startTimeCoded) }
        set { self.startTimeCoded = newValue.timeInMinutes }
    }

    /// The end time of the event
    var endTime: Time {
        get { Time(timeInMinutes: self.endTimeCoded) }
        set { self.endTimeCoded = newValue.timeInMinutes }
    }

    /// Represents the days as ints for which this event occurs on
    @Persisted private var daysList = RealmSwift.List<Int>()

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
        return self.occursOn(date: date) ? TimeChunk(startTime: self.startTime, endTime: self.endTime) : nil
    }
    
//    func detailsView() -> AnyView {
//        Log.e("Function should be overriden by subclass")
//        return AnyView(Text("Error showing details."))
//    }
//    
//    func editFormView() -> AnyView {
//        Log.e("Function should be overriden by subclass")
//        return AnyView(Text("Error showing edit form."))
//    }
}

extension RecurringStudiumEvent: GoogleCalendarRecurringEventLinking {
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
}

extension RecurringStudiumEvent: Searchable {
    func eventIsVisible(fromSearch searchText: String) -> Bool {
                return self.name.contains(searchText) ||
        //        self.startDate.formatted().contains(searchText) ||
        //        self.endDate.formatted().contains(searchText) ||
                self.location.contains(searchText)
    }
}

//extension RecurringStudiumEvent: CreatesDetailsView {
//    var detailsView: some View {
//        Text("View not specified")
//    }
//}

import SwiftUI

extension RecurringStudiumEvent {
//    var detailsView: some View {
//        HabitView(habit: self)
//    }

}

// extension RecurringStudiumEvent {
////    associatedtype T: View
////    var detailsView: T { get }
//    func detailsView() -> T
// }
