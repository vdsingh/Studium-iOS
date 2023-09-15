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
        self.name = newEvent.name
        self.location = newEvent.location
        self.additionalDetails = newEvent.additionalDetails
        self.startDate = newEvent.startDate
        self.endDate = newEvent.endDate
        if let autoschedulingConfig = newEvent.autoschedulingConfig {
            self.autoschedulingConfig = AutoschedulingConfig(
                autoLengthMinutes: autoschedulingConfig.autoLengthMinutes,
                autoscheduleInfinitely: autoschedulingConfig.autoscheduleInfinitely,
                useDatesAsBounds: autoschedulingConfig.useDatesAsBounds,
                autoschedulingDays: autoschedulingConfig.autoschedulingDays
            )
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
