//
//  Habit.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: RecurringStudiumEvent, Autoscheduleable{    
    
    var scheduledEvents: [Habit] = []
    
    
    //Autoschedule elements for a Habit object
    @Persisted var autoschedule: Bool = false //will this habit be scheduled automatically
    @Persisted var startEarlier: Bool = true //will this habit be scheduled earlier or later.
    
    //Time elements for a Habit object. 
    @Persisted var autoLengthMinutes: Int = 60

    @Persisted var systemImageString: String = "pencil"

    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
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
        systemImageString: String,
        color: UIColor,
        partitionKey: String
    ) {
//        self.init(
        self.init(name: name, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, color: color, alertTimes: alertTimes)
        self.autoschedule = autoschedule
        self.startEarlier = startEarlier
        self.autoLengthMinutes = autoLengthMinutes
        self.systemImageString = systemImageString
        
        let newDaysList = List<Int>()
        newDaysList.append(objectsIn: days.compactMap{ $0.rawValue })
        self.daysList = newDaysList
        
        self._partitionKey = partitionKey

    }
    
}
