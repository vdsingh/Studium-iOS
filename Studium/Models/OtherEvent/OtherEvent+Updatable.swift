//
//  OtherEvent+Updatable.swift
//  Studium
//
//  Created by Vikram Singh on 9/14/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

extension OtherEvent: Updatable {
    func updateFields(withNewEvent newEvent: OtherEvent) {
        self.startDate = newEvent.startDate
        self.endDate = newEvent.endDate
        self.location = newEvent.location
        self.name = newEvent.name
        self.additionalDetails = newEvent.additionalDetails
        self.alertTimes = newEvent.alertTimes
    }
}
