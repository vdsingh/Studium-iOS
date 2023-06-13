//
//  Assignment.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import VikUtilityKit

/// Represents Course Assignments
class Assignment: RecurringStudiumEvent, CompletableStudiumEvent, Autoscheduling, Autoscheduled, StudiumEventContained {
    
    typealias EventType = Assignment
        
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
    
    var autoscheduleInfinitely: Bool = false
    
    //TODO: Docstrings
    @Persisted var autoscheduled: Bool = false
        
    /// The number of minutes to autoschedule study time
    @Persisted var autoLengthMinutes: Int = 60
    
    /// The autoscheduled assignments that belong to this assignment
    @Persisted var autoscheduledEventsList: List<Assignment> = List<Assignment>()
    
    // TODO: Docstrings
    var autoscheduledEvents: [Assignment] {
        return [Assignment](self.autoscheduledEventsList)
    }
    
    /// Was this an autoscheduled assignment?
//    var isAutoscheduled: Bool {
//        self.parentAssignmentID != nil
//    }

    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    convenience init(
        name: String,
        additionalDetails: String,
        complete: Bool,
        startDate: Date,
        endDate: Date,
        notificationAlertTimes: [AlertOption],
        autoscheduling: Bool,
        autoLengthMinutes: Int,
        autoDays: Set<Weekday>,
        partitionKey: String = AuthenticationService.shared.userID ?? "",
        parentCourse: Course
    ) {
        self.init()
        self.name = name
        self.additionalDetails = additionalDetails
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
        
        self.autoscheduling = autoscheduling
        self.autoLengthMinutes = autoLengthMinutes
        
        self._partitionKey = partitionKey
                
        self.alertTimes = notificationAlertTimes

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
    
    // TODO: Docstring
    func appendAutoscheduledEvent(event: Assignment) {
//        self.scheduledEventsList.append(event)
        self.autoscheduledEventsList.append(event)
    }
    
    // TODO: Docstring
//    func removeScheduledEvent(event: Assignment) {
//        if let eventIndex = self.scheduledEventsList.firstIndex(where: { $0._id == event._id }) {
//            self.scheduledEventsList.remove(at: eventIndex)
//        } else {
//            print("$ERR (Assignment): Tried to remove assignment \(event.name) from scheduledEvents, but it was not in there to start.")
//        }
//    }
    
    
    func instantiateAutoscheduledEvent(forTimeChunk timeChunk: TimeChunk) -> Assignment {
        guard let parentCourse = self.parentCourse else {
            Log.s(AssignmentError.nilParentCourse, additionalDetails: "tried to instantiate an autoscheduled event for assignment \(self), but the parent course for this assignment was nil.")
            return Assignment()
        }
        
        let autoscheduledAssignment = Assignment(
            name: "Study Time",
            additionalDetails: "This Event is Study Time for Assignment: \(self.name)",
            complete: false,
            startDate: timeChunk.startDate,
            endDate: timeChunk.endDate,
            notificationAlertTimes: self.alertTimes,
            autoscheduling: false,
            autoLengthMinutes: self.autoLengthMinutes,
            autoDays: Set(),
            parentCourse: parentCourse
        )
        autoscheduledAssignment.autoscheduled = true
        return autoscheduledAssignment
    }
}

extension Assignment: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (Assignment): \(message)")
        }
    }
}

enum AssignmentError: Error {
    case nilParentCourse
}
