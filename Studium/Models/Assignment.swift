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
class Assignment: StudiumEvent, CompletableStudiumEvent, Autoscheduling, StudiumEventContained, FileStorer {
    
    typealias AutoscheduledEventType = OtherEvent
    
    @Persisted var attachedFileURLString: String? = nil
    
    /// Specifies whether or not the Assignment object is marked as complete or not
    @Persisted var complete: Bool = false

    /// This is a link to the Course that the Assignment object is categorized under
    @Persisted var parentCourse: Course?
    
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
        get { return self.parentCourse?.icon ?? .book }
        set { Log.e("Tried to set Assignment Icon") }
    }
    
    override var color: UIColor {
        get { return self.parentCourse?.color ?? StudiumColor.primaryAccent.uiColor }
        set { Log.e("Tried to set Assignment Color") }
    }

    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    convenience init(
        name: String,
        additionalDetails: String,
        complete: Bool,
        startDate: Date,
        endDate: Date,
        notificationAlertTimes: [AlertOption],
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
        if let course = self.parentCourse {
            return "\(self.endDate.format(with: "h:mm a")): \(self.name) due (\(course.name))"
        }
        
        return "\(self.endDate.format(with: "h:mm a")): \(self.name) due"
    }
    
    //TODO: Docstring
    override func occursOn(date: Date) -> Bool {
        return self.endDate.occursOn(date: date)
    }
    
    // TODO: Docstring
    func instantiateAutoscheduledEvent(forTimeChunk timeChunk: TimeChunk) -> OtherEvent {
        guard let parentCourse = self.parentCourse else {
            Log.s(AssignmentError.nilParentCourse, additionalDetails: "tried to instantiate an autoscheduled event for assignment \(self), but the parent course for this assignment was nil.")
            return OtherEvent()
        }
        
        let autoscheduledToDoEvent = OtherEvent(
            name: "Study Time",
            location: self.location,
            additionalDetails: "This Event is Study Time for Assignment \(self.name)",
            startDate: timeChunk.startDate,
            endDate: timeChunk.endDate,
            color: self.color,
            icon: self.icon,
            alertTimes: self.alertTimes
        )
        
        autoscheduledToDoEvent.autoscheduled = true
        return autoscheduledToDoEvent
    }
    
    // MARK: - Searchable
    override func eventIsVisible(fromSearch searchText: String) -> Bool {
        return self.name.contains(searchText) ||
        (self.parentCourse?.name ?? "").contains(searchText) ||
        self.dueDateString.contains(searchText) ||
        self.location.contains(searchText)
    }
}

extension Assignment: Updatable {
    func updateFields(withNewEvent newEvent: Assignment) {
        
//        var rerunAutoschedule = false
//        if (newEvent.autoscheduling && !self.autoscheduling) || (newEvent.autoschedulingDays != self.autoschedulingDays) {
//            // TODO: Implement reautoscheduling
//        }
            
        // update all of the fields
        self.name = newEvent.name
        self.additionalDetails = newEvent.additionalDetails
        self.complete = newEvent.complete
        self.startDate = newEvent.startDate
        self.endDate = newEvent.endDate
        self.alertTimes = newEvent.alertTimes
        if let autoschedulingConfig = newEvent.autoschedulingConfig {
            Log.d("Updating autoschedulingConfig with new config: \(autoschedulingConfig)")
            self.autoschedulingConfig = AutoschedulingConfig(
                autoLengthMinutes: autoschedulingConfig.autoLengthMinutes,
                autoscheduleInfinitely: autoschedulingConfig.autoscheduleInfinitely,
                useDatesAsBounds: autoschedulingConfig.useDatesAsBounds,
                autoschedulingDays: autoschedulingConfig.autoschedulingDays
            )
            
            Log.d("Autoscheduling Days List: \(autoschedulingConfig.autoschedulingDays)")
        }
        
        self.parentCourse = newEvent.parentCourse
    }
}

enum AssignmentError: Error {
    case nilParentCourse
}
