//
//  Course.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

/// Represents a school course or "class"
class Course: RecurringStudiumEvent, StudiumEventContainer {
        
    /// List of the assignments for the course.
    private let assignmentsList = List<Assignment>()
    
    /// The assignments associated with this course
    var containedEvents: [Assignment] {
        return [Assignment](self.assignmentsList)
    }

    // TODO: Docstrings
    convenience init (
        name: String,
        color: UIColor,
        location: String,
        additionalDetails: String,
        startTime: Time,
        endTime: Time,
        days: Set<Weekday>,
        icon: StudiumIcon,
        notificationAlertTimes: Set<AlertOption>
    ) {
        self.init()
        self.name = name
        self.color = color
        self.location = location
        self.additionalDetails = additionalDetails
        self.startTime = startTime
        self.endTime = endTime
        self.icon = icon
        self.alertTimes = notificationAlertTimes
        self.days = days
    }
    
    // MARK: - Public Functions
    
    // TODO: Docstrings
    func appendContainedEvent(containedEvent: Assignment) {
        self.assignmentsList.append(containedEvent)
    }
    
    // MARK: - View Related
    
    override class var displayName: String {
        return "Course"
    }
    
    override class var tabItemConfig: TabItemConfig {
        return .coursesFlow
    }
    
    override class var emptyListPositiveCTACardViewModel: ImageDetailViewModel {
        return ImageDetailViewModel(
            image: FlatImage.girlSittingOnBooks.uiImage,
            title: "No Courses here yet",
            subtitle: nil,
            buttonText: "Add a Course"
        )
    }
}

// MARK: - Mocking
extension Course {
    static func mock() -> Course {
        return Course(
            name: "Course name",
            color: StudiumEventColor.blue.uiColor,
            location: "Course Location",
            additionalDetails: "Course Additional Details",
            startTime: Time.noon,
            endTime: (Time.noon+60),
            days: [.tuesday, .thursday],
            icon: .basketball,
            notificationAlertTimes: [.fiveMin, .oneHour]
        )
    }
}
