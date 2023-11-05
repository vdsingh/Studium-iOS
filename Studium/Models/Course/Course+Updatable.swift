//
//  Course+Updatable.swift
//  Studium
//
//  Created by Vikram Singh on 9/14/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

extension Course: Updatable {
    func updateFields(withNewEvent newEvent: Course) {
        self.name = newEvent.name
        self.color = newEvent.color
        self.location = newEvent.location
        self.additionalDetails = newEvent.additionalDetails
        self.startTime = newEvent.startTime
        self.endTime = newEvent.endTime
        self.icon = newEvent.icon
        self.alertTimes = newEvent.alertTimes
        self.days = newEvent.days
        self._partitionKey = newEvent._partitionKey
    }
}
