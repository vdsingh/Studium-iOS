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
        days: [Int],
        systemImageString: String,
        colorHex: String,
        partitionKey: String
    ) {
        self.init()
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
        self.startDate = startDate
        self.endDate = endDate
        self.autoschedule = autoschedule
        self.startEarlier = startEarlier
        self.autoLengthMinutes = autoLengthMinutes
        self.systemImageString = systemImageString
        self.color = colorHex
        
        self._partitionKey = partitionKey
        for day in days {
            self.days.append(day)
        }
    }
    
}
