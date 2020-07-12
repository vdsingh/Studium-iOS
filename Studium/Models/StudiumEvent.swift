//
//  Event.swift
//  Studium
//
//  Created by Vikram Singh on 5/26/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

//protocol that is implemented by basically all classes that can be scheduled in DaySchedule and CalendarView

protocol StudiumEvent: Object{
    var name: String {get set}
    var startDate: Date {get set}
}
