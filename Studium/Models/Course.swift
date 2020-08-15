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
    //Basic String Elements of a Course object.
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = "4287f5"
    @objc dynamic var systemImageString: String = "pencil"

    @objc dynamic var location: String = ""
    @objc dynamic var additionalDetails: String = ""
    
    //Basic Date Elements of a Course object.
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    
    //List of the days that the course occurs on, which is used to schedule in the calendar and day views
    let days = List<String>()
    
    //List of the assignments for the course.
    let assignments = List<Assignment>()
    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    func initializeData(name: String, colorHex: String, location: String, additionalDetails: String, startDate: Date, endDate: Date, days: [String], systemImageString: String) {

        self.name = name
        self.color = colorHex
        self.location = location
        self.additionalDetails = additionalDetails
        self.startDate = startDate
        self.endDate = endDate
        self.systemImageString = systemImageString
        
        for day in days{
            self.days.append(day)
        }
    }
}
