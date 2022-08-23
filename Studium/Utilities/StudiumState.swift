//
//  StudiumState.swift
//  Studium
//
//  Created by Vikram Singh on 8/17/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
class StudiumState {
    public static var state = StudiumState()
    
//    var realm
    
    var courses: [Course] = []
    var habits: [Habit] = []
    var otherEvents: [OtherEvent] = []
    var assignments: [Assignment] = []
    
}
