//
//  Habit+Updatable.swift
//  Studium
//
//  Created by Vikram Singh on 9/14/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

extension Habit: Updatable {
    func updateFields(withNewEvent newEvent: Habit) {
        // TODO: implement reautoscheduling
        Log.d("Old start time: \(self.startTime). new Start time: \(newEvent.startTime)")
        Log.d("Old end time: \(self.endTime). new end time: \(newEvent.endTime)")

        self.name = newEvent.name
        self.location = newEvent.location
        self.additionalDetails = newEvent.additionalDetails
        self.startTime = newEvent.startTime
        self.endTime = newEvent.endTime
        if let autoschedulingConfig = newEvent.autoschedulingConfig {
            self.autoschedulingConfig = AutoschedulingConfig(
                autoLengthMinutes: autoschedulingConfig.autoLengthMinutes,
                startDateBound: autoschedulingConfig.startDateBound,
                endDateBound: autoschedulingConfig.endDateBound,
                startTimeBound: autoschedulingConfig.startTimeBound,
                endTimeBound: autoschedulingConfig.endTimeBound,
                autoschedulingDays: autoschedulingConfig.autoschedulingDays
            )
            //            self.autoschedulingConfig = AutoschedulingConfig(
            //                autoLengthMinutes: autoschedulingConfig.autoLengthMinutes,
            //                autoscheduleInfinitely: autoschedulingConfig.autoscheduleInfinitely,
            //                useDatesAsBounds: autoschedulingConfig.useDatesAsBounds,
//                autoschedulingDays: autoschedulingConfig.autoschedulingDays
//            )
        }
//        self.autoscheduling = newEvent.autoscheduling
//        self.startEarlier = newEvent.startEarlier
//        self.autoLengthMinutes = newEvent.autoLengthMinutes
        self.alertTimes = newEvent.alertTimes
        self.days = newEvent.days
        self.icon = newEvent.icon
        self.color = newEvent.color
        self._partitionKey = newEvent._partitionKey
    }
}
