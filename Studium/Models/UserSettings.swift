//
//  UserSettings.swift
//  Studium
//
//  Created by Vikram Singh on 4/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

//TODO: Docstring
final class UserSettings: Object {
    let debug = true
    
    //TODO: Docstrings
    @Persisted var _id = "UserSettings"
    
    //TODO: Docstrings
    @Persisted private var wakeUpTimes: List<WakeUpTime>
    
    //TODO: Docstrings
    @Persisted private var defaultAlertOptionRawValues: List<Int>
    
    //TODO: Docstrings
    var defaultAlertOptions: [AlertOption] {
        return self.defaultAlertOptionRawValues.compactMap({ AlertOption(rawValue: $0) })
    }
    
    //TODO: Docstrings
    convenience init(weekdayCases: [Weekday]) {
        self.init()
        
        for weekday in weekdayCases {
            let wakeUpTime = WakeUpTime(weekday: weekday, wakeUpTime: nil)
            self.wakeUpTimes.append(wakeUpTime)
        }
    }
    
    //TODO: Docstrings
    func getWakeUpTime(for date: Date) -> Date? {
        return self.wakeUpTimes.first(where: { $0.weekday == date.studiumWeekday })?.wakeUpTime ?? nil
    }
    
    //TODO: Docstrings
    func setWakeUpTime(for weekday: Weekday, wakeUpTime: Date?) {
        if let wakeUpTime = wakeUpTime,
           let wakeUpObject = self.wakeUpTimes.first(where: { $0.weekday.rawValue == weekday.rawValue }) {
            wakeUpObject.setWakeUpTime(wakeUpTime: wakeUpTime)
        }
    }
    
    //TODO: Docstrings
    func setDefaultAlertOptions(alertOptions: [AlertOption]) {
        self.defaultAlertOptionRawValues = List<Int>()
        for option in alertOptions {
            self.defaultAlertOptionRawValues.append(option.rawValue)
        }
    }
    
    override static func primaryKey() -> String? {
         return "_id"
    }
}

//TODO: Docstrings
final class WakeUpTime: Object, Debuggable {
    
    //TODO: Docstrings
    let debug = true
    
    //TODO: Docstrings
    @Persisted var _id = ObjectId.generate()
    
    //TODO: Docstrings
    @Persisted private var weekdayInt: Int
    
    //TODO: Docstrings
    @Persisted var wakeUpTime: Date?
    
    //TODO: Docstrings
    var weekday: Weekday {
        get { return Weekday(rawValue: self.weekdayInt) ?? .unknown }
        set { self.weekdayInt = newValue.rawValue }
    }
    
    //TODO: Docstrings
    convenience init(weekday: Weekday, wakeUpTime: Date?) {
        self.init()
        self.weekday = weekday
        self.wakeUpTime = wakeUpTime
    }
    
    //TODO: Docstrings
    func setWakeUpTime(wakeUpTime: Date) {
        self.wakeUpTime = wakeUpTime
        self.printDebug("Set wake up time for weekday value \(self.weekdayInt) to \(self.wakeUpTime)")
    }
    
    override static func primaryKey() -> String? {
         return "_id"
    }
    
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (WakeUpTime): \(message)")
        }
    }
}

extension UserSettings: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (UserSettings): \(message)")
        }
    }
}
