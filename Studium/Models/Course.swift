//
//  Course.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

// TODO: Docstrings
class Course: RecurringStudiumEvent, StudiumEventContainer {
        
    /// List of the assignments for the course.
    private let assignmentsList = List<Assignment>()
    
    // TODO: Docstrings
    var containedEvents: [Assignment] {
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
        
        let nextOccurringTimeChunk = self.nextOccuringTimeChunk
        self.startDate = nextOccurringTimeChunk?.startDate ?? startDate
        self.endDate = nextOccurringTimeChunk?.endDate ?? endDate
    }
    
    // MARK: - Public Functions
    
    // TODO: Docstrings
    func appendContainedEvent(containedEvent: Assignment) {
        self.assignmentsList.append(containedEvent)
    }
}

extension Course: Updatable {
    func updateFields(withNewEvent newEvent: Course) {
        self.name = newEvent.name
        self.color = newEvent.color
        self.location = newEvent.location
        self.additionalDetails = newEvent.additionalDetails
        self.startDate = newEvent.startDate
        self.endDate = newEvent.endDate
        self.icon = newEvent.icon
        self.alertTimes = newEvent.alertTimes
        self.days = newEvent.days
        self._partitionKey = newEvent._partitionKey
    }
}
