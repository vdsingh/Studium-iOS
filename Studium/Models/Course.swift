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
    private let assignmentsList = List<Assignment>()
    
    var assignments: [Assignment] {
        return [Assignment](assignmentsList)
    }

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
//        super.i
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
        
        self.days = days
//        self.notificationAlertTimes.removeAll()
//        for time in notificationAlertTimes{
//            self.notificationAlertTimes.append(time)
//        }
        
//        self.days.removeAll()
//        for day in days{
//            self.days.append(day)
//        }
    }
    
    // MARK: - Public Functions
    
    func appendAssignment(_ assignment: Assignment) {
        self.assignmentsList.append(assignment)
    }
    
    func setValues(
        name: String? = nil,
        color: UIColor? = nil,
        location: String? = nil,
        additionalDetails: String? = nil
    ) {
        if let name = name { self.name = name }
        if let color = color { self.color = color }
        if let location = location { self.location = location }
        if let additionalDetails = additionalDetails { self.name = additionalDetails }

    }
}
