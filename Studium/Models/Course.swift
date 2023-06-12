//
//  Course.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import VikUtilityKit

// TODO: Docstrings
class Course: RecurringStudiumEvent, StudiumEventContainer {
        
    /// List of the assignments for the course.
    private let assignmentsList = List<Assignment>()
    
    // TODO: Docstrings
    var scheduledEvents: [Assignment] {
        return [Assignment](self.assignmentsList)
    }

    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    
    // TODO: Docstrings
    convenience init (
        name: String,
        color: UIColor,
        location: String,
        additionalDetails: String,
        startDate: Date,
        endDate: Date,
        days: Set<Weekday>,
        icon: StudiumIcon,
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
        self.icon = icon
        self._partitionKey = partitionKey
        self.alertTimes = notificationAlertTimes
        self.days = days
    }
    
    // MARK: - Public Functions
    
    // TODO: Docstrings
    func appendScheduledEvent(scheduledEvent: Assignment) {
        self.assignmentsList.append(scheduledEvent)
    }
    
    // TODO: Docstrings
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
