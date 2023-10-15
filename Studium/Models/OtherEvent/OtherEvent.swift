//
//  OtherEvent.swift
//  Studium
//
//  Created by Vikram Singh on 6/29/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

// TODO: Docstrings
class OtherEvent: NonRecurringStudiumEvent, Autoscheduled, Codable {

    // TODO: Docstrings
//    @Persisted var complete: Bool = false

    // TODO: Docstrings
    @Persisted var autoscheduled: Bool = false

//    init(complete: Bool, autoscheduled: Bool) {
//        self.complete = complete
//        self.autoscheduled = autoscheduled
//    }

    // TODO: Docstrings
    convenience init(
        name: String,
        location: String,
        additionalDetails: String,
        startDate: Date,
        endDate: Date,
        alertTimes: Set<AlertOption>,
//        days: Set<Weekday>,
        icon: StudiumIcon,
        color: UIColor
    ) {
        self.init()
        self.name = name
        self.location = location
        self.additionalDetails = additionalDetails
        self.startDate = startDate
        self.endDate = endDate
        self.alertTimes = alertTimes
        self.icon = icon
        self.color = color
//        self.days
//        self.init(name: name, location: location, additionalDetails: additionalDetails, startTime: startTime, endTime: endTime, color: color, icon: icon, alertTimes: alertTimes)
//        self.autoschedulingConfig = autoschedulingConfig
//        self.days = days
//        let nextOccurringTimeChunk = self.nextOccuringTimeChunk
//        self.init(name: name, location: location, additionalDetails: additionalDetails, startDate: startDate, endDate: endDate, color: color, icon: icon, alertTimes: alertTimes)

//        self.init(name: <#T##String#>, location: <#T##String#>, additionalDetails: <#T##String#>, startDate: <#T##Date#>, endDate: <#T##Date#>, alertTimes: <#T##Set<AlertOption>#>, days: <#T##Set<Weekday>#>, icon: <#T##StudiumIcon#>, color: <#T##UIColor#>)
    }

    // TODO: Docstrings
//    func initializeData (
//        startDate: Date,
//        endDate: Date,
//        name: String,
//        location: String,
//        additionalDetails: String,
//        notificationAlertTimes: Set<AlertOption>,
//        partitionKey: String // FIXME: Remove
//    )
//    {
//        self.startDate = startDate
//        self.endDate = endDate
//        self.name = name
//        self.location = location
//        self.additionalDetails = additionalDetails
//        self._partitionKey = partitionKey
//        self.alertTimes = notificationAlertTimes
//    }
//    
//    // TODO: Docstrings
//    func initializeData(startDate: Date, endDate: Date, name: String, location: String, additionalDetails: String) {
//        self.startDate = startDate
//        self.endDate = endDate
//        self.name = name
//        self.location = location
//        self.additionalDetails = additionalDetails
//    }
}

extension OtherEvent {
    static func mock() -> OtherEvent {
//        return OtherEvent(name: "Other Event", 
//                          location: "Location",
//                          additionalDetails: "Additional Details",
//                          startDate: Date.distantPast,
//                          endDate: Date.distantPast.add(hours: 2),
//                          color: StudiumEventColor.green.uiColor, icon: .book,
//                          alertTimes: [.fifteenMin, .oneDay])

        return .init(name: "Other Event",
                     location: "Location",
                     additionalDetails: "Additional Details",
                     startDate: Date.someMonday,
                     endDate: Date.someMonday.add(hours: 2),
                     alertTimes: [.fiveMin, .fifteenMin],
                     icon: .bath,
                     color: StudiumEventColor.lightGreen.uiColor)
    }
}
