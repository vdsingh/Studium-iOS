//
//  AutoschedulingConfig.swift
//  Studium
//
//  Created by Vikram Singh on 9/14/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

/// Specification for how to autoschedule
struct AutoschedulingConfig: Codable, Equatable {
    
    // MARK: - Private Properties
    private var autoschedulingDaysList = List<Int>()
    
    // MARK: - Internal Properties
    
    /// The amount of time (in minutes) that autoscheduled events should be scheduled for
    var autoLengthMinutes: Int
    
    /// Whether we want to continuously autoschedule this event so long as it exists (otherwise, we'll use the event's endDate)
    var autoscheduleInfinitely: Bool
    
    /// Whether we use start date and end date as bounds for what time to autoschedule the event
    var useDatesAsBounds: Bool
    
    /// The days that events will be autoscheduled for
    var autoschedulingDays: Set<Weekday> {
        get {
            return Set<Weekday>( self.autoschedulingDaysList.compactMap { Weekday(rawValue: $0) })
        }
        set {
            let list = List<Int>()
            list.append(objectsIn: newValue.compactMap({ $0.rawValue }))
            self.autoschedulingDaysList = list
        }
    }
    
    // TODO: Docstrings
    init(autoLengthMinutes: Int, autoscheduleInfinitely: Bool, useDatesAsBounds: Bool, autoschedulingDays: Set<Weekday>) {
        self.autoLengthMinutes = autoLengthMinutes
        self.autoscheduleInfinitely = autoscheduleInfinitely
        self.useDatesAsBounds = useDatesAsBounds
        self.autoschedulingDays = autoschedulingDays
    }
}

extension AutoschedulingConfig {
    static func mock() -> AutoschedulingConfig {
        return AutoschedulingConfig(autoLengthMinutes: 60, autoscheduleInfinitely: false, useDatesAsBounds: false, autoschedulingDays: [.monday, .wednesday])
    }
}
