//
//  Autoscheduleable.swift
//  Studium
//
//  Created by Vikram Singh on 1/30/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import Foundation
import EventKit
import CalendarKit
import RealmSwift

class StudiumEvent: Object{
    /// id of the StudiumEvent
    @objc dynamic var _id: ObjectId = ObjectId.generate()
    
    /// partition key of the StudiumEvent
    @objc dynamic var _partitionKey: String = ""
    
    @objc dynamic var name: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var additionalDetails: String = ""

    
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    
    @objc dynamic var color: String = "ffffff"
    
    var notificationAlertTimes: List<Int> = List<Int>()
    var notificationIdentifiers: List<String> = List<String>()
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    func addToAppleCalendar(){
        func addToAppleCalendar(){
            let store = EKEventStore()
            let event = EKEvent(eventStore: store)
            
            let identifier = UserDefaults.standard.string(forKey: "appleCalendarID")
            if identifier == nil{ //the user is not synced with Apple Calendar
                return
            }
            
            event.location = location
            event.calendar = store.calendar(withIdentifier: identifier!) ?? store.defaultCalendarForNewEvents
            event.title = name
            event.startDate = startDate
            event.endDate = endDate
            event.notes = additionalDetails

            do{
                try store.save(event, span: EKSpan.futureEvents, commit: true)
            }catch let error as NSError{
                print("Failed to save event. Error: \(error)")
            }
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



