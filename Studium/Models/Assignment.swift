//
//  Assignment.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Assignment: RecurringStudiumEvent, Autoscheduleable{
    
    
    //Specifies whether or not the Assignment object is marked as complete or not. This determines where it lies in a tableView and whether or not it's crossed out.
    @objc dynamic var complete: Bool = false

    //This is a link to the Course that the Assignment object is categorized under.
    var parentCourse = LinkingObjects(fromType: Course.self, property: "assignments")
    
    //variables that track information about scheduling work time.
    @objc dynamic var autoschedule: Bool = false //in this case, autoschedule refers to scheduling work time.
//    @objc dynamic var autoLengthHours: Int = 1
    @objc dynamic var autoLengthMinutes: Int = 60
    
    @objc dynamic var scheduledEvents: [StudiumEvent] = []

    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    func initializeData(name: String, additionalDetails: String, complete: Bool, startDate: Date, endDate: Date, course: Course, notificationAlertTimes: [Int], autoschedule: Bool, autoLengthMinutes: Int, autoDays: [Int], partitionKey: String) {

        self.name = name
        self.additionalDetails = additionalDetails
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
        
        self.autoschedule = autoschedule
        self.autoLengthMinutes = autoLengthMinutes
        autoscheduleEvents(endDate: startDate, autoDays: autoDays, autoLengthMinutes: autoLengthMinutes)
        
        self._partitionKey = partitionKey
        
        self.notificationAlertTimes.removeAll()
        for alertTime in notificationAlertTimes{
            self.notificationAlertTimes.append(alertTime)
        }
        
        self.days.removeAll()
        for day in autoDays{
            self.days.append(day)
        }
    }
    
    func initializeData(name: String, additionalDetails: String, complete: Bool, startDate: Date, endDate: Date, course: Course) {
        self.name = name
        self.additionalDetails = additionalDetails
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
    }
    
    
    ///update the notifications for the Assignment. Removes all previous notification alerts, and replaces them with new alert times.
    ///
    /// - Parameters:
    ///     - endDate: the date in which we will stop scheduilng work time (this is generally the due date of the assignment)
    ///     - autoDays: the days of the week that we want to schedule work time (specified by user). Ex: ["Mon", "Wed", "Fri"]
    ///     - autoLengthMinutes: the amount of minutes to work for any given work time.
    func updateNotifications(with newAlertTimes: [Int]){
        var identifiersForRemoval: [String] = []
        for time in notificationAlertTimes{
            if !newAlertTimes.contains(time){ //remove the old alert time.
                print("\(time) was removed from notifications.")
                let index = notificationAlertTimes.firstIndex(of: time)!
                notificationAlertTimes.remove(at: index)
                identifiersForRemoval.append(notificationIdentifiers[index])
                notificationIdentifiers.remove(at: index)
            }
        }
        print("identifiers to be removed: \(identifiersForRemoval)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiersForRemoval)
    }
    
    ///returns a list of events for
    ///
    /// - Parameters:
    ///     - endDate: the date in which we will stop scheduilng work time (this is generally the due date of the assignment)
    ///     - autoDays: the days of the week that we want to schedule work time (specified by user). Ex: ["Mon", "Wed", "Fri"]
    ///     - autoLengthMinutes: the amount of minutes to work for any given work time.
    func autoscheduleEvents(endDate: Date, autoDays: [Int], autoLengthMinutes: Int){
        var events: [Assignment] = []
        //IMPORTANT NOTES:
        // 1) when autoscheduling on the day that it's due, make sure not to go over the dueDate. The finishing bound should be the dueDate
        var currentDate = Date()
        while(currentDate < endDate){
            for day in autoDays{
                //if the weekday of the currentDate is a weekday that we want to autoschedule on...
                if (autoDays.contains(currentDate.weekday)){
                    //autoschedule on the currentDate
                    let event: Assignment = autoscheduleOnDate(date: currentDate, startBound: Date(), endBound: Date(), earlier: true)
                    events.append(event)
                    break
                }
            }
            //add 24 hours to the currentDate so that we can look at the next day.
            currentDate += (60*60*24)
        }
        
        
        func autoscheduleOnDate(date: Date, startBound: Date, endBound: Date, earlier: Bool) -> Assignment{
            
            let newAssignment = Assignment()
            let eventStartDate = Date()
            
            newAssignment.initializeData(name: "Work on \(name)", additionalDetails: "This is automatically scheduled work time for assignment: \(name) from course: \(parentCourse[0])", complete: false, startDate: eventStartDate, endDate: eventStartDate + TimeInterval(autoLengthMinutes * 60), course: parentCourse[0])
            return newAssignment
        }
    }
    
    func isEventBetween(time1: Date, time2: Date) -> Bool{
//        let app = App(id: Secret.appID)
//        var realm: Realm!
//        guard let user = app.currentUser else{
//            print("There was an error accessing app's current user")
//            return true
//        }
//        realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
//        let courses = realm.objects(Course.self)
//        if let courses: Results<Course>? = realm.objects(Course.self){
//        for course in courses{
//            if course.days.contains(<#T##element: String##String#>)
//            if event.startDate <= time1 && event.startDate >= time2{ //the event completely overlaps the space
//                return true
//            }
//
//            if event.startDate >= time1 && event.startDate <= time2{ //the event starts within the space
//                return true
//            }
//
//            if event.endDate >= time1 && event.endDate <= time2{ //the event ends within the space
//                return true
//            }
//        }
        return false
    }
}


