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

// TODO: Docstrings, move
protocol DaySchedulable {
    var scheduleDisplayString: String { get }
    var scheduleDisplayColor: UIColor { get }
}

class StudiumEvent: Object, DaySchedulable {

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
    
    @Persisted var notificationIdentifiersList = List<String>()
    
    
    // MARK: - Computed Variables
    
    var color: UIColor {
        get { return UIColor(hexString: self.colorHex) ?? .black }
        set { self.colorHex = newValue.hexValue() }
    }
    
    var logo: SystemIcon {
        get { return SystemIcon(rawValue: self.logoString) ?? .book }
        set { self.logoString = newValue.rawValue }
    }
    
    var alertTimes: [AlertOption] {
        get { return self.alertTimesRaw.compactMap { AlertOption(rawValue: $0) } }
        set {
            alertTimesRaw = List<AlertOption.RawValue>()
            alertTimesRaw.append(objectsIn: newValue.compactMap { $0.rawValue })
        }
    }
    
    var notificationIdentifiers: [String] {
        get { return [String](self.notificationIdentifiersList) }
        set {
            self.notificationIdentifiersList = List<String>()
            self.notificationIdentifiersList.append(objectsIn: newValue)
        }
    }
    
    var totalLengthMinutes: Int {
        let diffComponents = Calendar.current.dateComponents([.minute], from: self.startDate, to: self.endDate)
//        endDate.minutes(from: startDate)
        if let minutes = diffComponents.minute {
            if minutes < 0 {
                fatalError("$ERR (StudiumEvent): negative minutes")
            }
            return minutes
        }
        
        print("$ERR (StudiumEvent): Couldn't get total length minutes from start and end date. returning 0")
        return 0
//        startDate.minutes
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
                print("$ERR: Failed to save event. Error: \(error)")
            }
        }
    }
    
    func setDates(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
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
    
    var scheduleDisplayString: String {
        return "\(self.startDate.format(with: "h:mm a")) - \(self.endDate.format(with: "h:mm a")): \(self.name)"
    }
    
    var scheduleDisplayColor: UIColor {
        return self.color
    }
}
