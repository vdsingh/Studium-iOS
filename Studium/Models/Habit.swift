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
    
    //TODO: Docstrings
    var scheduledEvents: [Habit] = []
    
    // MARK: - Autoscheduleable Variables
    @Persisted var autoschedule: Bool = false
    @Persisted var autoLengthMinutes: Int = 60
    @Persisted var startEarlier: Bool = true
    
    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    
    //TODO: Docstrings
    convenience init(
        name: String,
        location: String,
        additionalDetails: String,
        startDate: Date,
        endDate: Date,
        autoschedule: Bool,
        startEarlier: Bool,
        autoLengthMinutes: Int,
        alertTimes: [AlertOption],
        days: Set<Weekday>,
        logo: SystemIcon,
        color: UIColor,
        partitionKey: String
    ) {
        self.init(name: name, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, color: color, logo: logo, alertTimes: alertTimes)
        self.autoschedule = autoschedule
        self.startEarlier = startEarlier
        self.autoLengthMinutes = autoLengthMinutes
//        self.systemImageString = systemImageString
        
        let newDaysList = List<Int>()
        newDaysList.append(objectsIn: days.compactMap{ $0.rawValue })
        self.daysList = newDaysList
        
        self._partitionKey = partitionKey

    }
}
