//
//  AutoschedulingConfig.swift
//  Studium
//
//  Created by Vikram Singh on 9/14/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

struct AutoschedulingConfig: Codable {
    
    /// The amount of time (in minutes) that autoscheduled events should be scheduled for
    var autoLengthMinutes: Int
    
    /// Whether we want to continuously autoschedule this event so long as it exists (otherwise, we'll use the event's endDate)
    var autoscheduleInfinitely: Bool
    
    // TODO: Docstrings
    var useDatesAsBounds: Bool
    
    private var autoschedulingDaysList = List<Int>()
    
    var autoschedulingDays: Set<Weekday> {
        get {
            return Set<Weekday>( self.autoschedulingDaysList.compactMap { Weekday(rawValue: $0) })
        }
        set {
            Log.d("newValue: \(newValue)")
            let list = List<Int>()
            list.append(objectsIn: newValue.compactMap({ $0.rawValue }))
            self.autoschedulingDaysList = list
            Log.d("End Result \(self.autoschedulingDaysList)")
        }
    }
    
    init(autoLengthMinutes: Int, autoscheduleInfinitely: Bool, useDatesAsBounds: Bool, autoschedulingDays: Set<Weekday>) {
        self.autoLengthMinutes = autoLengthMinutes
        self.autoscheduleInfinitely = autoscheduleInfinitely
        self.useDatesAsBounds = useDatesAsBounds
        self.autoschedulingDays = autoschedulingDays
    }
}
