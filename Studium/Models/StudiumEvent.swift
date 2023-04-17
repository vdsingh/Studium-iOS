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
    
    /// The name of the StudiumEvent
    @Persisted var name: String = ""
    
    /// The location of the StudiumEvent
    @Persisted var location: String = ""
    
    /// The associated additional details of the StudiumEvent
    @Persisted var additionalDetails: String = ""

    //TODO: Docstrings
    @Persisted var startDate: Date = Date()
    
    
    @Persisted var endDate: Date = Date()
    
    
    // MARK: - Private Persisted Variables
    
    /// The Hex value of the associated color
    @Persisted private var colorHex: String = "ffffff"
    
    @Persisted private var logoString: String = SystemIcon.book.rawValue
    
    @Persisted private var alertTimesRaw = List<AlertOption.RawValue>()
    
    
    // MARK: - Computed Variables
    
    var alertTimes: [AlertOption] {
        get { return self.alertTimesRaw.compactMap { AlertOption(rawValue: $0) } }
        set {
            alertTimesRaw = List<AlertOption.RawValue>()
            alertTimesRaw.append(objectsIn: newValue.compactMap { $0.rawValue })
        }
    }
    
    var color: UIColor {
        get { return UIColor(hexString: self.colorHex) ?? .black }
        set { self.colorHex = newValue.hexValue() }
    }
    
    var logo: SystemIcon {
        get { return SystemIcon(rawValue: self.logoString) ?? .book }
        set { self.logoString = newValue.rawValue }
    }
    
    convenience init(
        name: String,
        location: String,
        additionalDetails: String,
        startDate: Date,
        endDate: Date,
        color: UIColor,
        logo: SystemIcon,
        alertTimes: [AlertOption]
    ) {
        self.init()
        
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
        self.startDate = startDate
        self.endDate = endDate
        self.color = color
        self.logo = logo
        self.alertTimes = alertTimes
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
    
    func setID(_ newID: ObjectId) {
        self._id = newID
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



