//
//  Habit.swift
//  Studium
//
//  Created by Vikram Singh on 5/27/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object{
    @objc dynamic var name: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var additionalDetails: String = ""
    
    @objc dynamic var startTime: Date = Date()
    @objc dynamic var endTime: Date = Date()
    
    @objc dynamic var autoSchedule: Bool = false //will this habit be scheduled automatically
    
    let days = List<String>()
    
}
