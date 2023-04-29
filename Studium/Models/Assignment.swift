//
//  Assignment.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

/// Represents Course Assignments
class Assignment: RecurringStudiumEvent, CompletableStudiumEvent, Autoscheduleable {
    
    let debug = true

    /// Specifies whether or not the Assignment object is marked as complete or not
    @Persisted var complete: Bool = false

    /// This is a link to the Course that the Assignment object is categorized under
    @Persisted var parentCourse: Course?
    
    /// Link to the parent Assignment if this is an autoscheduled study time
    @Persisted var parentAssignmentID: ObjectId?
        
    // MARK: - Variables that track information about scheduling work time.
    
    /// Whether or not scheduling work time is enabled
    @Persisted var autoschedule: Bool = false
        
    /// The number of minutes to autoschedule study time
    @Persisted var autoLengthMinutes: Int = 60
    
    //TODO: Docstring
    @Persisted var scheduledEvents: List<Assignment> = List<Assignment>()
    
    var scheduledEventsArr: [Assignment] {
        return [Assignment](self.scheduledEvents)
    }
    
    /// Was this an autoscheduled assignment?
    var isAutoscheduled: Bool {
        self.parentAssignmentID != nil
    }

    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    convenience init(
        name: String,
        additionalDetails: String,
        complete: Bool,
        startDate: Date,
        endDate: Date,
        notificationAlertTimes: [AlertOption],
        autoschedule: Bool,
        autoLengthMinutes: Int,
        autoDays: Set<Weekday>,
        partitionKey: String,
        parentCourse: Course
    ) {
        self.init()
        self.name = name
        self.additionalDetails = additionalDetails
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
        
        self.autoschedule = autoschedule
        self.autoLengthMinutes = autoLengthMinutes
        
        self._partitionKey = partitionKey
                
        self.alertTimes = alertTimes

        let newDaysList = List<Int>()
        newDaysList.append(objectsIn: autoDays.compactMap{ $0.rawValue })
        self.daysList = newDaysList
        
        self.parentCourse = parentCourse
    }
    
    //TODO: Docstring
    convenience init(parentAssignment: Assignment) {
        self.init()
        self.printDebug("Initializing assignment with parent assignment \(parentAssignment.name), which has autolength minutes \(parentAssignment.autoLengthMinutes)")
        self.name = "Work Time: \(parentAssignment.name)"
        self.additionalDetails = parentAssignment.additionalDetails
        self.complete = parentAssignment.complete
        
        self.startDate = parentAssignment.endDate.subtract(minutes: parentAssignment.autoLengthMinutes)
        self.endDate = parentAssignment.endDate

        self.autoschedule = false
        
        self.autoLengthMinutes = parentAssignment.autoLengthMinutes
        
        self._partitionKey = parentAssignment._partitionKey
                
        self.alertTimes = parentAssignment.alertTimes
        
        self.parentCourse = parentAssignment.parentCourse
        
        self.parentAssignmentID = parentAssignment._id
        self.printDebug("Initialized assignment with start and end \(parentAssignment.name)")
    }

    
    // TODO: Docstring
    override var scheduleDisplayString: String {
        if let course = self.parentCourse {
            return "\(self.endDate.format(with: "h:mm a")): \(self.name) due (\(course.name))"
        }
        
        return "\(self.endDate.format(with: "h:mm a")): \(self.name) due"
    }
}

extension Assignment: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (Assignment): \(message)")
        }
    }
}
