//
//  Event.swift
//  Studium
//
//  Created by Vikram Singh on 5/26/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

protocol StudiumEvent: Object {
    var name: String { get }
    var startTime: Date { get }
}
