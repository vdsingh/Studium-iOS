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
import VikUtilityKit

//TODO: Docstrings
class StudiumEvent: Object, ObjectKeyIdentifiable, AppleCalendarEvent, GoogleCalendarEventLinking, Identifiable {
    
//    @Persisted var shouldBeDeleted: Bool = false

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
    
    /// The start date of the event
    @Persisted var startDate: Date = Date()
    
    /// The end date of the event
    @Persisted var endDate: Date = Date()
    
    // TODO: Docstring
    @Persisted var ekEventID: String? = nil
    
    @Persisted var googleCalendarEventID: String? = nil

    
    // MARK: - Private Persisted Variables
    
    /// The Hex value of the associated color
    @Persisted private var colorHex: String = "ffffff"
    
    /// A String representing the raw value of the logo associated with the event
    @Persisted private var iconID: String = StudiumIcon.book.rawValue
    
    /// Raw representation of the alert times for this event
    @Persisted private var alertTimesRaw = List<AlertOption.RawValue>()
    
    /// Raw representation of the notification IDs for this event
    @Persisted private var notificationIdentifiersList = List<String>()
        
    // MARK: - Computed Variables
    
    /// The color for the event
    var color: UIColor {
        get { return UIColor(hexString: self.colorHex) ?? .black }
        set { self.colorHex = newValue.hexValue() }
    }
    
    /// The icon for the event
    var icon: StudiumIcon {
        get { return StudiumIcon(rawValue: self.iconID) ?? .book }
        set { self.iconID = newValue.rawValue }
    }
    
    /// The alert times for the event
    var alertTimes: [AlertOption] {
        get { return self.alertTimesRaw.compactMap { AlertOption(rawValue: $0) } }
        set {
            alertTimesRaw = List<AlertOption.RawValue>()
            alertTimesRaw.append(objectsIn: newValue.compactMap { $0.rawValue })
        }
    }
    
    /// The notification IDs for the event
    var notificationIdentifiers: [String] {
        get { return [String](self.notificationIdentifiersList) }
        set {
            self.notificationIdentifiersList = List<String>()
            self.notificationIdentifiersList.append(objectsIn: newValue)
        }
    }
    
    /// The total length of the event in minutes (calculated using the start and end date)
    var totalLengthMinutes: Int {
        let diffComponents = Calendar.current.dateComponents([.minute], from: self.startDate, to: self.endDate)
        if let minutes = diffComponents.minute {
            if minutes < 0 {
                fatalError("$ERR (StudiumEvent): negative minutes")
            }
            
            return minutes
        }
        
        Log.e("Couldn't get total length minutes from start and end date. returning 0")
        return 0
    }
    
    //TODO: Docstrings
    convenience init(
        name: String,
        location: String,
        additionalDetails: String,
        startDate: Date,
        endDate: Date,
        color: UIColor,
        icon: StudiumIcon,
        alertTimes: [AlertOption]
    ) {
        self.init()
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
        self.startDate = startDate
        self.endDate = endDate
        self.color = color
        self.icon = icon
        self.alertTimes = alertTimes
    }
    
    /// Sets the start and end dates for the event
    /// - Parameters:
    ///   - startDate: The start date of the event
    ///   - endDate: The end date of the event
    func setDates(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
    
    /// Sets the ID of the event
    /// - Parameter newID: The new ID of the event
    func setID(_ newID: ObjectId) {
        self._id = newID
    }
    
    /// Whether or not the event occurs on a given date
    /// - Parameter date: The date that we're checking
    /// - Returns: Whether or not the event occurs on the date
    func occursOn(date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self.startDate)
        let otherComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        return components.day == otherComponents.day &&
        components.month == otherComponents.month &&
        components.year == otherComponents.year
    }
    
    /// Returns a TimeChunk for this event on a given date
    /// - Parameter date: The date for which we want the TimeChunk
    /// - Returns: a TimeChunk for this event on a given date
    func timeChunkForDate(date: Date) -> TimeChunk? {
        // This event doesn't occur on the date. return nil.
        if !self.occursOn(date: date) {
            return nil
        }

        return TimeChunk(startDate: self.startDate, endDate: self.endDate)
    }
    
    //TODO: Docstrings
    var scheduleDisplayString: String {
        return "\(self.startDate.format(with: DateFormat.standardTime.formatString)) - \(self.endDate.format(with: DateFormat.standardTime.formatString)): \(self.name)"
    }
    
    //TODO: Docstrings
    var scheduleDisplayColor: UIColor {
        return self.color
    }
    
    override static func primaryKey() -> String? {
        return "_id"
    }
    
    // MARK: - Searchable
    func eventIsVisible(fromSearch searchText: String) -> Bool {
        return self.name.contains(searchText) ||
        self.startDate.formatted().contains(searchText) ||
        self.endDate.formatted().contains(searchText) ||
        self.location.contains(searchText)
    }
}
