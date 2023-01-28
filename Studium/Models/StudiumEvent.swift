//
//  Autoscheduleable.swift
//  Studium
//
//  Created by Vikram Singh on 1/30/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//


import Foundation
import EventKit
import RealmSwift

class StudiumEvent: Object {

    /// id of the StudiumEvent
    @Persisted var _id: ObjectId = ObjectId.generate()
    
    /// partition key of the StudiumEvent
    @Persisted var _partitionKey: String = ""
    
    @Persisted var name: String = ""
    @Persisted var location: String = ""
    @Persisted var additionalDetails: String = ""

    
    @Persisted var startDate: Date = Date()
    @Persisted var endDate: Date = Date()
    
    @Persisted var color: String = "ffffff"
    
    @Persisted private var alertTimesRaw = List<AlertOption.RawValue>()
    var alertTimes: [AlertOption] {
        get { return self.alertTimesRaw.compactMap { AlertOption(rawValue: $0) } }
        set {
            alertTimesRaw = List<AlertOption.RawValue>()
            alertTimesRaw.append(objectsIn: newValue.compactMap { $0.rawValue })
        }
    }

    override static func primaryKey() -> String? {
        return "_id"
    }
    
    //TODO: Move to different layer
    
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
                print("$Error: Failed to save event. Error: \(error)")
            }
        }
    }
    
    //TODO: Fix and abstract to a notification Layer
//    func deleteNotifications(){
//        var identifiers: [String] = []
//        for id in notificationIdentifiers{
//            identifiers.append(id)
//        }
//        notificationIdentifiers.removeAll()
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
//    }
}



