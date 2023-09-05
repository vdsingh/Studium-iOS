//
//  LinkConfig.swift
//  Studium
//
//  Created by Vikram Singh on 8/1/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

class LinkConfig: Object {
    @Persisted(primaryKey: true) var _id: ObjectId = ObjectId.generate()
    @Persisted var label: String
    @Persisted var link: String
    
    convenience init(label: String, link: String) {
        self.init()
        self.label = label
        self.link = link
    }
}
