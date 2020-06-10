//
//  Assignment.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Assignment: Object, StudiumEvent{
    @objc dynamic var name: String = ""
    @objc dynamic var additionalDetails: String = ""
    @objc dynamic var complete: Bool = false
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date()
    @objc dynamic var assignmentID: Int = 0
    
    @objc dynamic var startTime: Date = Date()
    
    func initializeData(name: String, additionalDetails: String, complete: Bool, startDate: Date, endDate: Date, assignmentID: Int) {

        self.name = name
        self.additionalDetails = additionalDetails
        self.complete = complete
        self.startDate = startDate
        self.endDate = endDate
        self.assignmentID = assignmentID
        
        startTime = startDate
    }
    
    
    //@objc dynamic var dateCreated = Date()
    
    var parentCourse = LinkingObjects(fromType: Course.self, property: "assignments")
    
}
