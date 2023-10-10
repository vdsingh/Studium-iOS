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
class Assignment: NonRecurringStudiumEvent, Autoscheduling, StudiumEventContained, FileStorer {
    
    typealias AutoscheduledEventType = OtherEvent
    
    @Persisted var attachedFileURLString: String? = nil
    
    /// Specifies whether or not the Assignment object is marked as complete or not
//    @Persisted var complete: Bool = false

    /// This is a link to the Course that the Assignment object is categorized under
    @Persisted var parentCourse: Course!
    
    // MARK: - Variables that track information about scheduling work time.
    
    /// Data for the configuration for autoscheduling
    @Persisted var autoschedulingConfigData: Data?

    /// The autoscheduled assignments that belong to this assignment
    @Persisted var autoscheduledEventsList: List<OtherEvent> = List<OtherEvent>()
        
    @Persisted private var resourceLinksList: List<LinkConfig>
    
    @Persisted var resourcesAreLoading: Bool = false
    
    @Persisted var isGeneratingEvents: Bool = false
    
    var resourceLinks: [LinkConfig] {
        get { return [LinkConfig](self.resourceLinksList) }
        set {
            let list = List<LinkConfig>()
            list.append(objectsIn: newValue)
            self.resourceLinksList = list
        }
    }
    
    var latenessStatus: LatenessStatus {
        if Date() > self.endDate {
            return .late
        } else if Date() + (60*60*24*3) > self.endDate {
            return .withinThreeDays
        } else {
            return .onTime
        }
    }
    
    // TODO: Docstrings
    
    var dueDateString: String {
        return self.endDate.format(with: .full)
    }
    
    /// Assignment Icon should be whatever the parent course's icon is
    override var icon: StudiumIcon {
        get { return self.parentCourse.icon }
        set { Log.e("Tried to set Assignment Icon") }
    }
    
    override var color: UIColor {
        get { return self.parentCourse.color }
        set { Log.e("Tried to set Assignment Color") }
    }

    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    convenience init(
        name: String,
        additionalDetails: String,
        complete: Bool,
        startDate: Date,
        endDate: Date,
        notificationAlertTimes: Set<AlertOption>,
        autoschedulingConfig: AutoschedulingConfig?,
        parentCourse: Course
    ) {
        self.init()
        self.name = name
        self.additionalDetails = additionalDetails
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
        self.autoschedulingConfig = autoschedulingConfig
        self._partitionKey = AuthenticationService.shared.userID ?? ""
        self.alertTimes = notificationAlertTimes
        self.parentCourse = parentCourse
    }
    
    /// The String that is displayed on a schedule view
    override var scheduleDisplayString: String {
//        if let course = self.parentCourse {
        return "\(self.endDate.format(with: "h:mm a")): \(self.name) due (\(self.parentCourse.name))"
//        }
        
//        return "\(self.endDate.format(with: "h:mm a")): \(self.name) due"
    }
    
    //TODO: Docstring
    override func occursOn(date: Date) -> Bool {
        return self.endDate.occursOn(date: date)
    }
    
    // TODO: Docstring
    func instantiateAutoscheduledEvents(datesAndTimeChunks: [(Date, TimeChunk)]) -> [OtherEvent] {
//        guard let parentCourse = self.parentCourse else {
//            Log.s(AssignmentError.nilParentCourse, additionalDetails: "tried to instantiate an autoscheduled event for assignment \(self), but the parent course for this assignment was nil.")
//            return []
//        }
        
        var events = [OtherEvent]()
        for (date, timeChunk) in datesAndTimeChunks {
            let startDate = date.setTime(hour: timeChunk.startTime.hour, minute: timeChunk.startTime.minute, second: 0)
            let endDate = date.setTime(hour: timeChunk.endTime.hour, minute: timeChunk.endTime.minute, second: 0)

            let autoscheduledToDoEvent = OtherEvent(
                name: "Study Time",
                location: self.location,
                additionalDetails: "This Event is Study Time for Assignment \(self.name)",
                startDate: startDate,
                endDate: endDate,
                alertTimes: self.alertTimes,
                icon: self.icon,
                color: self.color
            )
            autoscheduledToDoEvent.autoscheduled = true
            events.append(autoscheduledToDoEvent)
        }
        
        return events
    }
    
    // MARK: - Searchable
    func eventIsVisible(fromSearch searchText: String) -> Bool {
        return self.name.contains(searchText) ||
        (self.parentCourse.name).contains(searchText) ||
        self.dueDateString.contains(searchText) ||
        self.location.contains(searchText)
    }
}

enum AssignmentError: Error {
    case nilParentCourse
}

extension Assignment {
    static func mock(parentCourse: Course = Course.mock(), autoscheduling: Bool) -> Assignment {
        return autoscheduling ?
        Assignment(name: "Mock Autoscheduling Assignment",
                   additionalDetails: "Mock Additional Details",
                   complete: false, startDate: Date.someMonday,
                   endDate: Date.someMonday.add(hours: 1),
                   notificationAlertTimes: [.atTime, .fiveMin],
                   autoschedulingConfig: .init(
                    autoLengthMinutes: 20,
                    startDateBound: Date.someMonday,
                    endDateBound: Date.someMonday.add(weeks: 4),
                    startTimeBound: .nineAM,
                    endTimeBound: .fivePM,
                    autoschedulingDays: [.monday, .wednesday]),
                   parentCourse: Course.mock()) :
        Assignment(name: "Mock Assignment",
                   additionalDetails: "Mock Additional Details",
                   complete: false,
                   startDate: Date.someMonday,
                   endDate: Date.someMonday.add(hours: 1),
                   notificationAlertTimes: [.atTime, .fiveMin],
                   autoschedulingConfig: nil,
                   parentCourse: Course.mock()
        )
    }
}
