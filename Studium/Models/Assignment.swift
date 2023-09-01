//
//  Assignment.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

//protocol Autoscheduling: StudiumEvent {
//    
//    associatedtype AutoscheduledEventType: Autoscheduled
//    
//    /// Whether or not this event is in charge of autoscheduling other events
//    var autoscheduling: Bool { get set }
//    
//    /// The amount of time (in minutes) that autoscheduled events should be scheduled for
//    var autoLengthMinutes: Int { get set }
//    
//    /// Whether we want to continuously autoschedule this event so long as it exists (otherwise, we'll use the event's endDate)
//    var autoscheduleInfinitely: Bool { get set }
//    
//    // TODO: Docstrings
//    var autoscheduledEvents: [AutoscheduledEventType] { get }
//    
//    //TODO: Docstrings
//    func appendAutoscheduledEvent(event: AutoscheduledEventType)
//    
//    //TODO: Docstrings
//    func instantiateAutoscheduledEvent(forTimeChunk timeChunk: TimeChunk) -> AutoscheduledEventType
//    
//    // TODO: Docstrings
//    var autoschedulingDays: Set<Weekday> { get set }
//    
//    // TODO: Docstrings
//    var useDatesAsBounds: Bool { get }
//    
//    /// Flag for whether host is waiting on autoscheduled events to be scheduled (i.e., display a loading indicator)
//    var isGeneratingEvents: Bool { get set }
//}




import Foundation
import RealmSwift
import VikUtilityKit

/// Represents Course Assignments
class Assignment: StudiumEvent, CompletableStudiumEvent, Autoscheduling, StudiumEventContained, FileStorer {
    
//    let debug = true
    typealias AutoscheduledEventType = OtherEvent
    
    @Persisted var attachedFileURLString: String? = nil
    
    /// Specifies whether or not the Assignment object is marked as complete or not
    @Persisted var complete: Bool = false

    /// This is a link to the Course that the Assignment object is categorized under
    @Persisted var parentCourse: Course?
    
    /// Link to the parent Assignment if this is an autoscheduled study time
//    @Persisted var parentAssignmentID: ObjectId?
        
    // MARK: - Variables that track information about scheduling work time.
    
    /// Whether or not scheduling work time is enabled
//    @Persisted var autoscheduling: Bool = false
    
    @Persisted var autoschedulingConfigData: Data?
    
//    var autoscheduleInfinitely: Bool = false
    
//    var useDatesAsBounds: Bool = false
    
            
    /// The number of minutes to autoschedule study time. Nil if Assignment is not autoscheduling
//    @Persisted var autoLengthMinutes: Int? = nil
    
    /// The autoscheduled assignments that belong to this assignment
    @Persisted var autoscheduledEventsList: List<OtherEvent> = List<OtherEvent>()
    
    // TODO: Docstrings
//    @Persisted var autoschedulingDaysList: List<Int>
    
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
    
    // TODO: Docstrings
//    var autoscheduledEvents: [OtherEvent] {
//        return [OtherEvent](self.autoscheduledEventsList)
//    }
    
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
//        autoscheduling: Bool,
//        autoLengthMinutes: Int,
//        autoDays: Set<Weekday>?,
        partitionKey: String = AuthenticationService.shared.userID ?? "",
        parentCourse: Course
    ) {
        self.init()
        self.name = name
        self.additionalDetails = additionalDetails
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
        
        self.autoschedulingConfig = autoschedulingConfig
        
//        self.autoscheduling = autoscheduling
//        self.autoLengthMinutes = autoLengthMinutes
        
        self._partitionKey = partitionKey
                
        self.alertTimes = notificationAlertTimes

//        self.autoschedulingDays = autoDays
        
        self.parentCourse = parentCourse
    }
    
    /// Initializer for autoscheduled assignments
    /// - Parameter parentAssignment: The parent Assignment to which the autoscheduled assignment belongs
//    convenience init(parentAssignment: Assignment) {
//        self.init()
//        self.printDebug("Initializing assignment with parent assignment \(parentAssignment.name), which has autolength minutes \(parentAssignment.autoLengthMinutes)")
//        self.name = "Work Time: \(parentAssignment.name)"
//        self.additionalDetails = parentAssignment.additionalDetails
//        self.complete = parentAssignment.complete
//        
//        self.startDate = parentAssignment.endDate.subtract(minutes: parentAssignment.autoLengthMinutes)
//        self.endDate = parentAssignment.endDate
//        
//        if self.startDate > self.endDate
//        {
//            //TODO: Remove
//            fatalError("Start date is later than end date")
//        }
//
//        self.autoscheduling = false
//        
//        self.autoLengthMinutes = parentAssignment.autoLengthMinutes
//        
//        self._partitionKey = parentAssignment._partitionKey
//                
//        self.alertTimes = parentAssignment.alertTimes
//        
//        self.parentCourse = parentAssignment.parentCourse
//        
//        self.parentAssignmentID = parentAssignment._id
//        self.printDebug("Initialized assignment with start and end \(parentAssignment.name)")
//    }
    
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
//    func appendAutoscheduledEvent(event: OtherEvent) {
//        self.autoscheduledEventsList.append(event)
//    }
    
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
    
    func instantiateAssignmentWidgetModel() -> AssignmentWidgetModel {
        return AssignmentWidgetModel(
            id: self._id.stringValue,
            name: self.name,
            dueDate: self.endDate,
            course: self.parentCourse?.name ?? "",
            isComplete: self.complete,
            colorHex: self.color.hexValue()
        )
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
//            // FIXME: Implement reautoscheduling
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
