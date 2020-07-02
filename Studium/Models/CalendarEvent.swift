//
//  CalendarEvent.swift
//  Studium
//
//  Created by Vikram Singh on 5/25/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation

struct CalendarEvent { //contains charactersitics of all CalendarEvents.
    let startDate: Date
    let endDate: Date
    let title: String
    let location: String

    init (startDate: Date, endDate: Date, title: String, location: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.title = title
        self.location = location
    }
}
