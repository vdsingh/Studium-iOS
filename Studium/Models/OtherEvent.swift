//
//  OtherEvent.swift
//  Studium
//
//  Created by Vikram Singh on 6/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class OtherEvent: Object, StudiumEvent{
    @objc dynamic var startTime: Date = Date()
    @objc dynamic var endTime: Date = Date()
    
    @objc dynamic var name: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var additionalDetails: String = ""
    @objc dynamic var complete: Bool = false
    
    func initializeData(startTime: Date, endTime: Date, name: String, location: String, additionalDetails: String){
        self.startTime = startTime
        self.endTime = endTime
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
    }
}
