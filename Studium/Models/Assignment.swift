//
//  Assignment.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Assignment: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var complete: Bool = false
    //@objc dynamic var dateCreated = Date()
    
    var parentCategory = LinkingObjects(fromType: Course.self, property: "assignments")
}
