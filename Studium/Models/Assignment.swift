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
    var parentCourses = LinkingObjects(fromType: Course.self, property: "assignments")
    var parentCourse: Course? { return parentCourses.first }
        
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
        partitionKey: String
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
    
    func initiateAutoSchedule(){
        if autoschedule {
            var autoDays: [Weekday] = []
            for day in days{
                autoDays.append(day)
            }
            autoscheduleTime(endDate: startDate, autoDays: autoDays, autoLengthMinutes: autoLengthMinutes)
        }
    }
    
    ///returns a list of events for
    ///
    /// - Parameters:
    ///     - endDate: the date in which we will stop scheduling work time (this is generally the due date of the assignment)
    ///     - autoDays: the days of the week that we want to schedule work time (specified by user). Ex: ["Mon", "Wed", "Fri"]
    ///     - autoLengthMinutes: the amount of minutes to work for any given work time.
    func autoscheduleTime(endDate: Date, autoDays: [Weekday], autoLengthMinutes: Int) {
        print("$Log: attempting to autoschedule work time for \(name)")
        
        //IMPORTANT NOTES:
        // 1) when autoscheduling on the day that it's due, make sure not to go over the dueDate. The finishing bound should be the dueDate
        var currentDate = Date()
        while(currentDate < endDate) {
                // if the weekday of the currentDate is a weekday that we want to autoschedule on...
            let autoDayRawValues = autoDays.compactMap({ $0.rawValue })
            if (autoDayRawValues.contains(currentDate.weekday)) {
                // autoschedule on the currentDate
                let wakeUpTime = UserDefaults.standard.array(forKey: K.wakeUpKeyDict[currentDate.weekday]!)![0] as! Date
                
                let startBound = Date(year: currentDate.year, month: currentDate.month, day: currentDate.day, hour: wakeUpTime.hour, minute: wakeUpTime.minute, second: 0)
                var endBound = Date(year: currentDate.year, month: currentDate.month, day: currentDate.day, hour: 23, minute: 59, second: 0)
                
                // if the currentDate is the dueDate of the assignment
                if (currentDate.day == endDate.day){
                    endBound = endDate
                }
                
                if let event = autoscheduleOnDate(date: currentDate, startBound: startBound, endBound: endBound) {
//                    let user = DatabaseService.shared.user
                    let realm = DatabaseService.shared.realm
                    do { //adding the assignment to the courses list of assignments
                        try realm.write{
                            self.scheduledEvents.append(event)
                        }
                    } catch {
                        print("$Error: error appending assignment")
                    }
                    print("$Log: added an event to scheduledEvents. scheduledEvents count: \(scheduledEvents.count)")

                }else{
                    print("$Error: autoscheduleOnDate returned nil")
                }

            }
            //add 24 hours to the currentDate so that we can look at the next day.
            currentDate += (60*60*24)
        }
        
        ///Given a date, will automatically schedule work time for this assignment.
        ///
        /// - Parameters:
        ///     - date: the date on which we want to autoschedule work time
        ///     - startBound: the start bound time for when to autoschedule the assignment
        ///     - endBound: the end bound time for when to autoschedule the assignment
        ///     - earlier: true if we want to schedule work time earlier. false if later.
        /// - Returns: a 2D date Array that describes all open time slots
        func autoscheduleOnDate(date: Date, startBound: Date, endBound: Date) -> Assignment?{
            let commitments = Autoschedule.getCommitments(date: date)
            let openTimeSlots = Autoschedule.getOpenTimeSlots(startBound: startBound, endBound: endBound, commitments: commitments)
            if openTimeSlots.count == 0{
                print("There were no open time slots on day \(date) to schedule work time for \(name).")
                return nil
            }
            let startAndEnd = Autoschedule.bestTime(openTimeSlots: openTimeSlots, totalMinutes: autoLengthMinutes)
            if startAndEnd == nil {
                return nil
            }
            let assignmentStart = startAndEnd![0]
            let assignmentEnd = startAndEnd![1]
            
            print("startAndEnd: \(startAndEnd ?? [])")

            let newAssignment = Assignment(
                name: "Work on \(name)",
                additionalDetails: "This is an automatically scheduled event to work on \(name).",
                complete: false,
                startDate: assignmentStart,
                endDate: assignmentEnd,
                notificationAlertTimes: [],
                autoschedule: false,
                autoLengthMinutes: autoLengthMinutes,
                autoDays: [],
                partitionKey: DatabaseService.shared.user?.id ?? ""
            )
            
            newAssignment.isAutoscheduled = true
            DatabaseService.shared.saveStudiumObject(newAssignment)
//            RealmCRUD.saveAssignment(assignment: newAssignment, parentCourse: parentCourse!)
            return newAssignment
        }
    }
}

