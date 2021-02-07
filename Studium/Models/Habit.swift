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
    
    //Autoschedule elements for a Habit object
    @objc dynamic var autoschedule: Bool = false //will this habit be scheduled automatically
    @objc dynamic var startEarlier: Bool = true //will this habit be scheduled earlier or later.
    
    //Time elements for a Habit object. 
    @objc dynamic var autoLengthHours: Int = 1
    @objc dynamic var autoLengthMinutes: Int = 0

    @objc dynamic var systemImageString: String = "pencil"

    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    func initializeData(name: String, location: String, additionalDetails: String, startDate: Date, endDate: Date, autoschedule: Bool, startEarlier: Bool, autoLengthHours: Int, autoLengthMinutes: Int, days: [String], systemImageString: String, colorHex: String, partitionKey: String) {

        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
        self.startDate = startDate
        self.endDate = endDate
        self.autoschedule = autoschedule
        self.startEarlier = startEarlier
        self.autoLengthHours = autoLengthHours
        self.autoLengthMinutes = autoLengthMinutes
        self.systemImageString = systemImageString
        self.color = colorHex
        
        self._partitionKey = partitionKey
        
        //handles days
        for day in days{
            self.days.append(day)
        }
    }
    
    
}
