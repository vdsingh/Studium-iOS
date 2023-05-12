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
class Habit: RecurringStudiumEvent, Autoscheduleable {
    
    // MARK: - Autoscheduleable Variables
    
    //TODO: Docstrings
    @Persisted var autoscheduling: Bool = false
    
    //TODO: Docstrings
    @Persisted var autoLengthMinutes: Int = 60
    
    //TODO: Docstrings
    @Persisted var autoscheduled: Bool = false
    
    //TODO: Docstrings
    @Persisted var scheduledEventsList = List<StudiumEvent>()
    
    //TODO: Docstrings
    @Persisted var startEarlier: Bool = true
        
    // TODO: Docstrings
    var scheduledEvents: [StudiumEvent] {
        return [StudiumEvent](self.scheduledEventsList)
    }
    
    // TODO: Docstrings
    var scheduledEventsArr: [Habit] {
        var scheduledAssignments = [Habit]()
        for event in self.scheduledEventsList {
            if let assignment = event as? Habit {
                scheduledAssignments.append(assignment)
            } else {
                print("$ERR (Assigment): A non-Assignment event was added to assignments scheduled events. Event: \(event)")
            }
        }
        return scheduledAssignments
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
        logo: SystemIcon,
        color: UIColor,
        partitionKey: String
    ) {
        self.init(name: name, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, color: color, logo: logo, alertTimes: alertTimes)
        self.startEarlier = startEarlier
        self.autoscheduling = autoscheduling
        self.autoLengthMinutes = autoLengthMinutes
        let newDaysList = List<Int>()
        newDaysList.append(objectsIn: days.compactMap{ $0.rawValue })
        self.daysList = newDaysList
        self._partitionKey = partitionKey
    }
    
    //TODO: Docstrings
    override func occursOn(date: Date) -> Bool {
        if self.autoscheduling {
            return false
        } else {
            return super.occursOn(date: date)
        }
    }
    
    //TODO: Docstrings
    func appendScheduledEvent(event: StudiumEvent) {
        if let event = event as? Assignment {
            self.scheduledEventsList.append(event)
        } else {
            print("$ERR (Assignment): cannot add event \(event.name) to assignments autoscheduled")
        }
    }
}
