//
//  Course.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Course: RecurringStudiumEvent{
    @objc dynamic var systemImageString: String = "pencil"

    //List of the assignments for the course.
    let assignments = List<Assignment>()
//    @objc dynamic var testVar: String = "TEST"

    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    func initializeData(name: String, colorHex: String, location: String, additionalDetails: String, startDate: Date, endDate: Date, days: [Int], systemImageString: String, notificationAlertTimes: [Int], partitionKey: String) {
        
        self.name = name
        self.color = colorHex
        self.location = location
        self.additionalDetails = additionalDetails
        self.startDate = startDate
        self.endDate = endDate
        self.systemImageString = systemImageString
        self._partitionKey = partitionKey
        //        self.notificationAlertTimes = notificationAlertTimes
        self.notificationAlertTimes.removeAll()
        for time in notificationAlertTimes{
            self.notificationAlertTimes.append(time)
        }
        
        self.days.removeAll()
        for day in days{
            self.days.append(day)
        }
    }
    
    

}
