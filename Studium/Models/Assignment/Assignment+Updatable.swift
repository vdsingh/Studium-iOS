//
//  Assignment+Updatable.swift
//  Studium
//
//  Created by Vikram Singh on 9/14/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

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
