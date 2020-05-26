//
//  Course.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Course: Object, StudiumEvent{
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = "eb4034"
    @objc dynamic var location: String = ""
    
    @objc dynamic var startTimeHour: Int = 0
    @objc dynamic var startTimeMinute: Int = 0
    
    @objc dynamic var endTimeHour: Int = 0
    @objc dynamic var endTimeMinute: Int = 0

    
    let days = List<String>()
    let assignments = List<Assignment>()
}
