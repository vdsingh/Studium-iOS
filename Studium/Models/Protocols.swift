//
//  Autoscheduleable.swift
//  Studium
//
//  Created by Vikram Singh on 1/30/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

protocol StudiumEvent: Object{
    var name: String {get set}
    
    var startDate: Date {get set}
    var endDate: Date{get set}
    
    var color: String{get set}
    
    var notificationAlertTimes: List<Int> {get set}
    var notificationIdentifiers: List<String> {get set}
    func deleteNotifications()
}

protocol Autoscheduleable: StudiumEvent{
    var autoLengthHours: Int {get set}
    var autoLengthMinutes: Int {get set}
    
//    var autoDays: List<String> {get set}
    
    var autoschedule: Bool {get set}
}

protocol Recurring: StudiumEvent{
    var days: List<String> {get set}
}
