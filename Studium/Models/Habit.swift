//
//  Habit.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object, StudiumEvent{
    //Basic String elements for a Habit object
    @objc dynamic var name: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var additionalDetails: String = ""
    
    //Basic Date elements for a Habit object
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date() //if autoschedule, this is last bound
    
    //Autoschedule elements for a Habit object
    @objc dynamic var autoSchedule: Bool = false //will this habit be scheduled automatically
    @objc dynamic var startEarlier: Bool = true //will this habit be scheduled earlier or later.
    
    //Time elements for a Habit object. 
    @objc dynamic var totalHourTime: Int = 0
    @objc dynamic var totalMinuteTime: Int = 0
    
    //Other elements that determine the looks of the habit 
    @objc dynamic var color: String = "4287f5"
    @objc dynamic var systemImageString: String = "pencil"



    //List of days that this habit occurs on.
    let days = List<String>()
    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    func initializeData(name: String, location: String, additionalDetails: String, startDate: Date, endDate: Date, autoSchedule: Bool, startEarlier: Bool, totalHourTime: Int, totalMinuteTime: Int, daysSelected: [String], systemImageString: String, colorHex: String) {

        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
        self.startDate = startDate
        self.endDate = endDate
        self.autoSchedule = autoSchedule
        self.startEarlier = startEarlier
        self.totalHourTime = totalHourTime
        self.totalMinuteTime = totalMinuteTime
        self.systemImageString = systemImageString
        self.color = colorHex
        
        //handles days
        for day in daysSelected{
            self.days.append(day)
        }
    }
}
