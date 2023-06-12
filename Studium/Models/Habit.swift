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
        
    /// The events that this event has scheduled (as Habits)
//    var scheduledEventsArr: [Habit] {
//        var scheduledAssignments = [Habit]()
//        for event in self.scheduledEventsList {
//            if let assignment = event as? Habit {
//                scheduledAssignments.append(assignment)
//            } else {
//                print("$ERR (Assigment): A non-Assignment event was added to assignments scheduled events. Event: \(event)")
//            }
//        }
//        return scheduledAssignments
//    }
    
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
    
//    private init(
//        name: String,
//        location: String,
//        additionalDetails: String,
//        startDate: Date,
//        endDate: Date,
//        autoscheduling: Bool,
//        startEarlier: Bool,
//        autoLengthMinutes: Int,
//        alertTimes: [AlertOption],
//        days: Set<Weekday>,
//        icon: StudiumIcon,
//        color: UIColor,
//        partitionKey: String
//    ) {
//
//    }
//
    /// Whether or not this event occurs on a specified date
    /// - Parameter date: The specified date
    /// - Returns: Whether or not this event occurs on the specified date
    override func occursOn(date: Date) -> Bool {
        if self.autoscheduling {
            return false
        } else {
            return super.occursOn(date: date)
        }
    }

    /// Adds a scheduled event to this event's scheduled events
    /// - Parameter event: The StudiumEvent to add
    func appendAutoscheduledEvent(event: OtherEvent) {
        self.autoscheduledEventsList.append(event)
//        if let event = event as? Assignment {
//            self.scheduledEventsList.append(event)
//        } else {
//            print("$ERR (Assignment): cannot add event \(event.name) to assignments autoscheduled")
//        }
    }
        
    func instantiateAutoscheduledEvent(forTimeChunk timeChunk: TimeChunk) -> OtherEvent {
//        let autoscheduledHabit = Habit(
//            name: self.name,
//            location: self.location,
//            additionalDetails: "This Habit was Autoscheduled.",
//            startDate: timeChunk.startDate,
//            endDate: timeChunk.endDate,
//            autoscheduling: false,
//            startEarlier: self.startEarlier,
//            autoLengthMinutes: self.autoLengthMinutes,
//            alertTimes: self.alertTimes,
//            days: Set(),
//            icon: <#T##StudiumIcon#>,
//            color: <#T##UIColor#>,
//            partitionKey: <#T##String#>
//        )
        
//        return autoscheduledHabit
        
        let otherEvent = OtherEvent()
        return OtherEvent()
    }
}
