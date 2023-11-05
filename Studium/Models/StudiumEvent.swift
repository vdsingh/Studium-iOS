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
import SwiftUI



//TODO: Docstrings
class StudiumEvent: Object, ObjectKeyIdentifiable, AppleCalendarEvent, Identifiable {
    
    /// id of the StudiumEvent
    @Persisted var _id: ObjectId = ObjectId.generate()
    // swiftlint:disable:previous identifier_name

    /// partition key of the StudiumEvent
    @Persisted var _partitionKey: String = AuthenticationService.shared.userID ?? UUID().uuidString
    // swiftlint:disable:previous identifier_name

    /// The name of the StudiumEvent
    @Persisted var name: String = ""

    /// The location of the StudiumEvent
    @Persisted var location: String = ""

    /// The associated additional details of the StudiumEvent
    @Persisted var additionalDetails: String = ""

    // TODO: Docstring
    @Persisted var ekEventID: String?

    @Persisted var googleCalendarEventID: String?

    // MARK: - Private Persisted Variables

    /// The Hex value of the associated color
    @Persisted private var colorHex: String = "ffffff"

    /// A String representing the raw value of the logo associated with the event
    @Persisted private var iconID: String = StudiumIcon.book.rawValue

    /// Raw representation of the alert times for this event
    @Persisted private var alertTimesRaw = RealmSwift.List<AlertOption.RawValue>()

    /// Raw representation of the notification IDs for this event
    @Persisted private var notificationIdentifiersList = RealmSwift.List<String>()

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
    var alertTimes: Set<AlertOption> {
        get { return Set<AlertOption>(self.alertTimesRaw.compactMap { AlertOption(rawValue: $0) }) }
        set {
            self.alertTimesRaw = RealmSwift.List<AlertOption.RawValue>()
            self.alertTimesRaw.append(objectsIn: newValue.compactMap { $0.rawValue })
        }
    }

    /// The notification IDs for the event
    var notificationIdentifiers: [String] {
        get { return [String](self.notificationIdentifiersList) }
        set {
            self.notificationIdentifiersList = RealmSwift.List<String>()
            self.notificationIdentifiersList.append(objectsIn: newValue)
        }
    }

    /// The total length of the event in minutes (calculated using the start and end date)
//    var totalLengthMinutes: Int {
//        let diffComponents = Calendar.current.dateComponents([.minute], from: self.startDate, to: self.endDate)
//        if let minutes = diffComponents.minute {
//            if minutes < 0 {
//                fatalError("$ERR (StudiumEvent): negative minutes")
//            }
//            
//            return minutes
//        }
//        
//        Log.e("Couldn't get total length minutes from start and end date. returning 0")
//        return 0
//    }

    // TODO: Docstrings
//    convenience init(
//        name: String,
//        location: String,
//        additionalDetails: String,
//        color: UIColor,
//        icon: StudiumIcon,
//        alertTimes: Set<AlertOption>
//    ) {
//        self.init()
//        self.name = name
//        self.location = location
//        self.additionalDetails = additionalDetails
//        self.color = color
//        self.icon = icon
//        self.alertTimes = alertTimes
//    }

    /// Sets the ID of the event
    /// - Parameter newID: The new ID of the event
//    func setID(_ newID: ObjectId) {
//        self._id = newID
//    }

    /// Whether or not the event occurs on a given date
    /// - Parameter date: The date that we're checking
    /// - Returns: Whether or not the event occurs on the date
    func occursOn(date: Date) -> Bool {
        fatalError("Should be overriden")
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.day, .month, .year], from: self.startDate)
//        let otherComponents = calendar.dateComponents([.day, .month, .year], from: date)
//        
//        return components.day == otherComponents.day &&
//        components.month == otherComponents.month &&
//        components.year == otherComponents.year
    }

    /// Returns a TimeChunk for this event on a given date
    /// - Parameter date: The date for which we want the TimeChunk
    /// - Returns: a TimeChunk for this event on a given date
    func timeChunkForDate(date: Date) -> TimeChunk? {
        fatalError("Should be overriden")
        // This event doesn't occur on the date. return nil.
//        if !self.occursOn(date: date) {
//            return nil
//        }
//
//        return TimeChunk(startTime: self.startDate.time, endTime: self.endDate.time)
    }

    // TODO: Docstrings
    var scheduleDisplayString: String {
        fatalError("Should be overriden")
//        return "\(self.startDate.format(with: DateFormat.standardTime)) - \(self.endDate.format(with: DateFormat.standardTime)): \(self.name)"
    }

    // TODO: Docstrings

    override static func primaryKey() -> String? {
        return "_id"
    }

    // MARK: - Searchable
//    func eventIsVisible(fromSearch searchText: String) -> Bool {
//        fatalError("Should be overriden")
//        return self.name.contains(searchText) ||
//        self.startDate.formatted().contains(searchText) ||
//        self.endDate.formatted().contains(searchText) ||
//        self.location.contains(searchText)
//    }

    // MARK: - View Related

    // MARK: Class (relating to StudiumEvent as a type)

    /// How to display the type to users
    class var displayName: String {
        return "Event"
    }

    /// Creates a form to add a new event of this type
    /// - Returns: A view for a form to add a new event of this type
    class func addFormView() -> AnyView {
        Log.e("Function should be overriden by subclass")
        return AnyView(EmptyView())
    }

    /// Config to specify how item in tab bar should look
    class var tabItemConfig: TabItemConfig {
        Log.e("Function should be overriden by subclass")
        return .unknown
    }

    /// Specifies how the Positive CTA card should look if list is empty. NOTE: Button action should be set separately using viewModel.setButtonAction
    class var emptyListPositiveCTACardViewModel: ImageDetailViewModel {
        return ImageDetailViewModel(
            image: FlatImage.womanFlying.uiImage,
            title: "No \(self.displayName)s here yet",
            subtitle: nil,
            buttonText: "Add a \(self.displayName)"
        )
    }

    // MARK: Instance (relating to the specific StudiumEvent instance)

    /// Creates a View to show the details of this event in a modal view
    /// - Returns: a View that shows the details of this event in a modal view
    func detailsView() -> AnyView {
        Log.e("Function should be overriden by subclass")
        return AnyView(Text("Error showing details."))
    }

    /// Creates a form to edit this event
    /// - Returns: A view for a form to edit this event
    func editFormView() -> AnyView {
        Log.e("Function should be overriden by subclass")
        return AnyView(Text("Error showing edit form."))
    }
}
