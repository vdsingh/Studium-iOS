//
//  Course.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Course: RecurringStudiumEvent {
//    @Persisted var systemImageString: String = SystemIcon.pencil.rawValue
    
    /// List of the assignments for the course.
    let assignments = List<Assignment>()

    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    convenience init (
        name: String,
        color: UIColor,
        location: String,
        additionalDetails: String,
        startDate: Date,
        endDate: Date,
        days: Set<Weekday>,
        logo: SystemIcon,
        notificationAlertTimes: [AlertOption],
        partitionKey: String
    ) {
        self.init()
        self.name = name
        self.color = color
        self.location = location
        self.additionalDetails = additionalDetails
        self.startDate = startDate
        self.endDate = endDate
        self.logo = logo
//        self.systemImageString = systemImageString
        self._partitionKey = partitionKey
//        self.
        self.alertTimes = notificationAlertTimes
//        self.notificationAlertTimes.removeAll()
//        for time in notificationAlertTimes{
//            self.notificationAlertTimes.append(time)
//        }
        
//        self.days.removeAll()
//        for day in days{
//            self.days.append(day)
//        }
    }
}
