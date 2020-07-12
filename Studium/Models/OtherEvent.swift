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
    //Basic String elements for an OtherEvent object
    @objc dynamic var name: String = ""
    @objc dynamic var location: String = ""
    @objc dynamic var additionalDetails: String = ""
    
    //Basic Date elements for an OtherEvent object
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var startDate: Date = Date()
    //Specifies whether or not the OtherEvent object is marked as complete or not. This determines where it lies in a tableView and whether or not it's crossed out.
    @objc dynamic var complete: Bool = false
    
    //Basically an init that must be called manually because Realm doesn't allow init for some reason.
    func initializeData(startDate: Date, endDate: Date, name: String, location: String, additionalDetails: String){
        self.startDate = startDate
        self.endDate = endDate
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
    }
}
