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
    
    /// Does this event autoschedule other events?
//    @Persisted var autoscheduling: Bool = false
    
    ///If this event is autoscheduling, how long should scheduled events be?
//    @Persisted var autoLengthMinutes: Int = 60
    
//    /// Was this event autoscheduled by another event?
//    @Persisted var autoscheduled: Bool = false
    
    //TODO: Docstrings
//    @Persisted var autoscheduledEventsList = List<OtherEvent>()
    
    //TODO: Docstrings
//    @Persisted var startEarlier: Bool = true
    
    /// Autoscheduling Habits should autoschedule until they are deleted.
//    var autoscheduleInfinitely: Bool = true
        
    /// The events that this event has scheduled. We use OtherEvents as autoscheduled Habit events.
//    var autoscheduledEvents: [OtherEvent] {
//        return [OtherEvent](self.autoscheduledEventsList)
//    }
    
    // TODO: Docstring
//    var autoschedulingDays: Set<Weekday> {
//        get { return self.days }
//        set { self.days = newValue}
//    }
    
//    var useDatesAsBounds: Bool = true
    
//    @Persisted var isGeneratingEvents: Bool = false
    
    
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
//        autoscheduling: Bool,
//        startEarlier: Bool,
//        autoLengthMinutes: Int,
        alertTimes: [AlertOption],
        days: Set<Weekday>,
        icon: StudiumIcon,
        color: UIColor
//        partitionKey: String
    ) {
        self.init(name: name, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, color: color, icon: icon, alertTimes: alertTimes)
//        self.startEarlier = startEarlier
        self.autoschedulingConfig = autoschedulingConfig
//        self.autoscheduling = autoscheduling
//        self.autoLengthMinutes = autoLengthMinutes
        self.days = days
//        self._partitionKey = partitionKey
        
        let nextOccurringTimeChunk = self.nextOccuringTimeChunk
        self.startDate = nextOccurringTimeChunk?.startDate ?? startDate
        self.endDate = nextOccurringTimeChunk?.endDate ?? endDate
    }

    /// Adds a scheduled event to this event's scheduled events
    /// - Parameter event: The StudiumEvent to add
//    func appendAutoscheduledEvent(event: OtherEvent) {
//        self.autoscheduledEventsList.append(event)
//    }
        
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
