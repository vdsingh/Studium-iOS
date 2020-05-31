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
    @objc dynamic var name: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var additionalDetails: String = ""
    
    @objc dynamic var startTime: Date = Date() //if autoschedule, this is first bound
    @objc dynamic var endTime: Date = Date()
    
    @objc dynamic var autoSchedule: Bool = false //will this habit be scheduled automatically
    @objc dynamic var startEarlier: Bool = true
    
    @objc dynamic var totalHourTime: Int = 0
    @objc dynamic var totalMinuteTime: Int = 0

    let days = List<String>()
    
}
