//
//  Assignment.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Assignment: Object, StudiumEvent{
    
    //Basic String elements for an Assignment object
    @objc dynamic var name: String = ""
    @objc dynamic var additionalDetails: String = ""
    
    //Basic Date elements for an Assignment object. The endDate is when it is due, and the startDate is just so that the element appears on the DayView
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    
    //Specifies whether or not the Assignment object is marked as complete or not. This determines where it lies in a tableView and whether or not it's crossed out.
    @objc dynamic var complete: Bool = false
    
    //track the identifiers of all notifications associated with this assignment.
    let notificationIdentifiers = List<String>()
    let notificationAlertTimes = List<Int>()

    //This is a link to the Course that the Assignment object is categorized under.
    var parentCourse = LinkingObjects(fromType: Course.self, property: "assignments")
    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    func initializeData(name: String, additionalDetails: String, complete: Bool, startDate: Date, endDate: Date, course: Course, notificationAlertTimes: [Int]) {

        self.name = name
        self.additionalDetails = additionalDetails
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
        
        self.notificationAlertTimes.removeAll()
        for alertTime in notificationAlertTimes{
            self.notificationAlertTimes.append(alertTime)
        }
        
    }
    
    func deleteNotifications(){
        var identifiers: [String] = []
        for id in notificationIdentifiers{
            identifiers.append(id)
        }
        notificationIdentifiers.removeAll()
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
