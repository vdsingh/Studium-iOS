//
//  OtherEvent.swift
//  Studium
//
//  Created by Vikram Singh on 6/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

// TODO: Docstrings
class OtherEvent: StudiumEvent, CompletableStudiumEvent, Autoscheduled, Codable {
    
    // TODO: Docstrings
    @Persisted var complete: Bool = false
    
    // TODO: Docstrings
    @Persisted var autoscheduled: Bool = false

    // TODO: Docstrings
    func initializeData (
        startDate: Date,
        endDate: Date,
        name: String,
        location: String,
        additionalDetails: String,
        notificationAlertTimes: [AlertOption],
        partitionKey: String // FIXME: Remove
    )
    {
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
        self._partitionKey = partitionKey
        self.alertTimes = notificationAlertTimes
    }
    
    // TODO: Docstrings
    func initializeData(startDate: Date, endDate: Date, name: String, location: String, additionalDetails: String){
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
    }
}
