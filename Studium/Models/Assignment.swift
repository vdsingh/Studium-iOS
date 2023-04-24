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

    /// Specifies whether or not the Assignment object is marked as complete or not..
    @Persisted var complete: Bool = false

    /// This is a link to the Course that the Assignment object is categorized under.
//    private var parentCourses = LinkingObjects(fromType: Course.self, property: "assignments")
    
    @Persisted var parentCourse: Course?
        
    //variables that track information about scheduling work time.
    
    /// Whether or not scheduling work time is enabled
    @Persisted var autoschedule: Bool = false
    
    //was this an autoscheduled assignment?
    @Persisted var isAutoscheduled: Bool = false
    
//    @Persisted var autoLengthHours: Int = 1
    @Persisted var autoLengthMinutes: Int = 60
    
//    var autoDays: [Int] = []
    var scheduledEvents: List<Assignment> = List<Assignment>()

    
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
//        self.notificationAlertTimes.removeAll()
//        for alertTime in notificationAlertTimes{
//            self.notificationAlertTimes.append(alertTime)
//        }
        
        let newDaysList = List<Int>()
        newDaysList.append(objectsIn: autoDays.compactMap{ $0.rawValue })
        self.daysList = newDaysList
        
        self.parentCourse = parentCourse
    }
    
    convenience init(
        name: String,
        additionalDetails: String,
        complete: Bool,
        startDate: Date,
        endDate: Date
    )
    {
        self.init()
        self.name = name
        self.additionalDetails = additionalDetails
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
    }
    
    
    //TODO: Fix and move to different layer
    
    ///update the notifications for the Assignment. Removes all previous notification alerts, and replaces them with new alert times.
    ///
    /// - Parameters:
    ///     - newAlertTimes: array of integers that provide the new alert times
    func updateNotifications(with newAlertTimes: [Int]){
//        var identifiersForRemoval: [String] = []
//        for time in notificationAlertTimes{
//            if !newAlertTimes.contains(time){ //remove the old alert time.
//                print("\(time) was removed from notifications.")
//                let index = notificationAlertTimes.firstIndex(of: time)!
//                notificationAlertTimes.remove(at: index)
//                identifiersForRemoval.append(notificationIdentifiers[index])
//                notificationIdentifiers.remove(at: index)
//            }
//        }
//        print("identifiers to be removed: \(identifiersForRemoval)")
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersForRemoval)
    }
    
    //TODO: Initiate
//    func initiateAutoSchedule(){
//        if autoschedule {
//            var autoDays: [Weekday] = []
//            for day in days{
//                autoDays.append(day)
//            }
//            autoscheduleTime(endDate: startDate, autoDays: autoDays, autoLengthMinutes: autoLengthMinutes)
//        }
//    }
    
    override var scheduleDisplayString: String {
        if let course = self.parentCourse {
            return "\(self.endDate.format(with: "h:mm a")): \(self.name) due (\(course.name))"
        }
        
        return "\(self.endDate.format(with: "h:mm a")): \(self.name) due"
    }
    
}

