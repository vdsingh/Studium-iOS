//
//  Habit.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import VikUtilityKit

//TODO: Docstrings
class Habit: RecurringStudiumEvent, Autoscheduling {    
    
    // MARK: - Autoscheduleable Variables
    
    /// Does this event autoschedule other events?
    @Persisted var autoscheduling: Bool = false
    
    ///If this event is autoscheduling, how long should scheduled events be?
    @Persisted var autoLengthMinutes: Int = 60
    
//    /// Was this event autoscheduled by another event?
//    @Persisted var autoscheduled: Bool = false
    
    //TODO: Docstrings
    @Persisted var autoscheduledEventsList = List<OtherEvent>()
    
    //TODO: Docstrings
    @Persisted var startEarlier: Bool = true
    
    /// Autoscheduling Habits should autoschedule until they are deleted.
    var autoscheduleInfinitely: Bool = true
        
    /// The events that this event has scheduled. We use OtherEvents as autoscheduled Habit events.
    var autoscheduledEvents: [OtherEvent] {
        return [OtherEvent](self.autoscheduledEventsList)
    }
    
    // TODO: Docstring
    var autoschedulingDays: Set<Weekday> {
        get { return self.days }
        set { self.days = newValue}
    }
    
    //TODO: Docstrings
    convenience init(
        name: String,
        location: String,
        additionalDetails: String,
        startDate: Date,
        endDate: Date,
        autoscheduling: Bool,
        startEarlier: Bool,
        autoLengthMinutes: Int,
        alertTimes: [AlertOption],
        days: Set<Weekday>,
        icon: StudiumIcon,
        color: UIColor,
        partitionKey: String
    ) {
        self.init(name: name, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, color: color, icon: icon, alertTimes: alertTimes)
        self.startEarlier = startEarlier
        self.autoscheduling = autoscheduling
        self.autoLengthMinutes = autoLengthMinutes
        let newDaysList = List<Int>()
        newDaysList.append(objectsIn: days.compactMap{ $0.rawValue })
        self.daysList = newDaysList
        self._partitionKey = partitionKey
    }

    /// Adds a scheduled event to this event's scheduled events
    /// - Parameter event: The StudiumEvent to add
    func appendAutoscheduledEvent(event: OtherEvent) {
        self.autoscheduledEventsList.append(event)
    }
        
    func instantiateAutoscheduledEvent(forTimeChunk timeChunk: TimeChunk) -> OtherEvent {
        let otherEvent = OtherEvent(name: self.name, location: self.location, additionalDetails: "This Event was Autoscheduled by your Habit: \(self.name)", startDate: timeChunk.startDate, endDate: timeChunk.endDate, color: self.color, icon: self.icon, alertTimes: self.alertTimes)
        return otherEvent
    }
}

extension Habit: Updatable {
    func updateFields(withNewEvent newEvent: Habit) {
        // TODO: implement reautoscheduling
        self.name = newEvent.name
        self.location = newEvent.location
        self.additionalDetails = newEvent.additionalDetails
        self.startDate = newEvent.startDate
        self.endDate = newEvent.endDate
        self.autoscheduling = newEvent.autoscheduling
        self.startEarlier = newEvent.startEarlier
        self.autoLengthMinutes = newEvent.autoLengthMinutes
        self.alertTimes = newEvent.alertTimes
        self.days = newEvent.days
        self.icon = newEvent.icon
        self.color = newEvent.color
        self._partitionKey = newEvent._partitionKey
    }
}
