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
    @objc dynamic var autoLengthHours: Int = 1
    @objc dynamic var autoLengthMinutes: Int = 0

    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    func initializeData(name: String, additionalDetails: String, complete: Bool, startDate: Date, endDate: Date, course: Course, notificationAlertTimes: [Int], autoschedule: Bool, autoLengthHours: Int, autoLengthMinutes: Int, autoDays: [String], partitionKey: String) {

        self.name = name
        self.additionalDetails = additionalDetails
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
        
        self.autoschedule = autoschedule
        self.autoLengthHours = autoLengthHours
        self.autoLengthMinutes = autoLengthMinutes
        
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
}
