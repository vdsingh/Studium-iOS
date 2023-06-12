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
class OtherEvent: StudiumEvent, CompletableStudiumEvent, Autoscheduled {
    
    
    //Specifies whether or not the OtherEvent object is marked as complete or not. This determines where it lies in a tableView and whether or not it's crossed out.
    
    // TODO: Docstrings
    @Persisted var complete: Bool = false
    
    @Persisted var autoscheduled: Bool = false
    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    
    // TODO: Docstrings
    func initializeData (
        startDate: Date,
        endDate: Date,
        name: String,
        location: String,
        additionalDetails: String,
        notificationAlertTimes: [AlertOption],
        partitionKey: String)
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
