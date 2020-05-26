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
    @objc dynamic var name: String = "math homework"
    @objc dynamic var additionalDetails: String = "in the goonies"
    @objc dynamic var complete: Bool = false
    @objc dynamic var startDate: Date = Date()
    @objc dynamic var endDate: Date = Date(timeInterval: 3600, since: Date())
    
    //@objc dynamic var dateCreated = Date()
    
    var parentCourse = LinkingObjects(fromType: Course.self, property: "assignments")
    
}
