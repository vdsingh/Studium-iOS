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
    @Persisted var autoscheduling: Bool = false
    
    //TODO: Docstrings
    @Persisted var autoscheduled: Bool = false
        
    /// The number of minutes to autoschedule study time
    @Persisted var autoLengthMinutes: Int = 60
    
    /// The autoscheduled assignments that belong to this assignment
    @Persisted private var scheduledEventsList: List<StudiumEvent> = List<StudiumEvent>()
    
    
//    var scheduledEvents: [StudiumEvent]

    var scheduledEvents: [StudiumEvent] {
        return [StudiumEvent](self.scheduledEventsList)
    }
    
    var scheduledEventsArr: [Assignment] {
        var scheduledAssignments = [Assignment]()
        for event in self.scheduledEventsList {
            if let assignment = event as? Assignment {
                scheduledAssignments.append(assignment)
            } else {
                print("$ERR (Assigment): A non-Assignment event was added to assignments scheduled events. Event: \(event)")
            }
        }
        return scheduledAssignments
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
        
        self.autoscheduling = autoschedule
        self.autoLengthMinutes = autoLengthMinutes
        
        self._partitionKey = partitionKey
                
        self.alertTimes = alertTimes

        let newDaysList = List<Int>()
        newDaysList.append(objectsIn: autoDays.compactMap{ $0.rawValue })
        self.daysList = newDaysList
        
        self.parentCourse = parentCourse
    }
    
    /// Initializer for autoscheduled assignments
    /// - Parameter parentAssignment: The parent Assignment to which the autoscheduled assignment belongs
    convenience init(parentAssignment: Assignment) {
        self.init()
        self.printDebug("Initializing assignment with parent assignment \(parentAssignment.name), which has autolength minutes \(parentAssignment.autoLengthMinutes)")
        self.name = "Work Time: \(parentAssignment.name)"
        self.additionalDetails = parentAssignment.additionalDetails
        self.complete = parentAssignment.complete
        
        self.startDate = parentAssignment.endDate.subtract(minutes: parentAssignment.autoLengthMinutes)
        self.endDate = parentAssignment.endDate
        
        if self.startDate > self.endDate
        {
            fatalError("Start date is later than end date")
        }

        self.autoscheduling = false
        
        self.autoLengthMinutes = parentAssignment.autoLengthMinutes
        
        self._partitionKey = parentAssignment._partitionKey
                
        self.alertTimes = parentAssignment.alertTimes
        
        self.parentCourse = parentAssignment.parentCourse
        
        self.parentAssignmentID = parentAssignment._id
        self.printDebug("Initialized assignment with start and end \(parentAssignment.name)")
    }
    
    /// The String that is displayed on a schedule view
    override var scheduleDisplayString: String {
        if let course = self.parentCourse {
            return "\(self.endDate.format(with: "h:mm a")): \(self.name) due (\(course.name))"
        }
        
        return "\(self.endDate.format(with: "h:mm a")): \(self.name) due"
    }
    
    //TODO: Docstring
    override func occursOn(date: Date) -> Bool {
        return self.endDate.occursOn(date: date)
    }
    
    func appendScheduledEvent(event: StudiumEvent) {
        self.scheduledEventsList.append(event)
    }
}

extension Assignment: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (Assignment): \(message)")
        }
    }
}
