//
//  GoogleCalendarEventStoring.swift
//  Studium
//
//  Created by Vikram Singh on 6/17/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import EventKit

// TODO: Docstrings
protocol GoogleCalendarEventLinking {
    var name: String { get set }
    var startDate: Date { get set }
    var endDate: Date { get set }
    var googleCalendarEventID: String? { get set }
}

protocol GoogleCalendarRecurringEventLinking: GoogleCalendarEventLinking {
    var ekRecurrenceRule: EKRecurrenceRule { get }
}
