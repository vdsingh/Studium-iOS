//
//  Habit.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift


//TODO: Docstrings
class Habit: RecurringStudiumEvent, Autoscheduling {
    
    typealias AutoscheduledEventType = OtherEvent
    
    // MARK: - Autoscheduleable Variables
    
    //TODO: Docstrings
    @Persisted var autoscheduledEventsList = List<OtherEvent>()
    
    @Persisted var autoschedulingConfigData: Data?
    
    //TODO: Docstrings
    convenience init(
        name: String,
        location: String,
        additionalDetails: String,
        startDate: Date,
        endDate: Date,
        autoschedulingConfig: AutoschedulingConfig?,
        alertTimes: [AlertOption],
        days: Set<Weekday>,
        icon: StudiumIcon,
        color: UIColor
    ) {
        self.init(name: name, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, color: color, icon: icon, alertTimes: alertTimes)
        self.autoschedulingConfig = autoschedulingConfig
        self.days = days
        let nextOccurringTimeChunk = self.nextOccuringTimeChunk
        self.startDate = nextOccurringTimeChunk?.startDate ?? startDate
        self.endDate = nextOccurringTimeChunk?.endDate ?? endDate
    }

    func instantiateAutoscheduledEvent(forTimeChunk timeChunk: TimeChunk) -> OtherEvent {
        let otherEvent = OtherEvent(name: self.name, location: self.location, additionalDetails: "This Event was Autoscheduled by your Habit: \(self.name)", startDate: timeChunk.startDate, endDate: timeChunk.endDate, color: self.color, icon: self.icon, alertTimes: self.alertTimes)
        otherEvent.autoscheduled = true
        return otherEvent
    }
    
    override func timeChunkForDate(date: Date) -> TimeChunk? {
        if self.autoscheduling {
            return nil
        }
        
        return super.timeChunkForDate(date: date)
    }
}

extension Habit {
    static func mock(autoscheduling: Bool) -> Habit {
        let autoschedulingConfig: AutoschedulingConfig? = autoscheduling ? .mock() : nil
        return Habit(name: "Mock Habit", location: "Mock Location", additionalDetails: "Mock Additional Details", startDate: Time.noon.arbitraryDateWithTime, endDate: Time.noon.adding(hours: 1, minutes: 0).arbitraryDateWithTime, autoschedulingConfig: autoschedulingConfig, alertTimes: [.fiveMin, .fifteenMin], days: [.monday, .wednesday], icon: .binoculars, color: StudiumEventColor.blue.uiColor)
    }
}

extension Habit: ComparableWithoutId {
    func isEqualWithoutId(to event: Habit) -> Bool {
        return self.name == event.name &&
        self.location == event.location &&
        self.additionalDetails == event.additionalDetails &&
        self.startDate.time == event.startDate.time &&
        self.endDate.time == event.endDate.time &&
        self.autoschedulingConfig == event.autoschedulingConfig &&
        self.alertTimes == event.alertTimes &&
        self.days == event.days &&
        self.icon == event.icon &&
        self.color == event.color
    }
}

protocol ComparableWithoutId {
    associatedtype EventType
    func isEqualWithoutId(to event: EventType) -> Bool
}
