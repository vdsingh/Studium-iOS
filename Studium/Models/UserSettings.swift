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
    
    @Persisted var _id = "UserSettings"
    
    @Persisted private var wakeUpTimes: List<WakeUpTime>
    
    convenience init(weekdayCases: [Weekday]) {
        self.init()
        
        for weekday in weekdayCases {
            let wakeUpTime = WakeUpTime(weekday: weekday, wakeUpTime: nil)
            self.wakeUpTimes.append(wakeUpTime)
        }
    }
    
    func getWakeUpTime(for date: Date) -> Date? {
        return self.wakeUpTimes.first(where: { $0.weekday == date.studiumWeekday })?.wakeUpTime ?? nil
    }
    
    func setWakeUpTime(for weekday: Weekday, wakeUpTime: Date?) {
        if let wakeUpTime = wakeUpTime,
           let wakeUpObject = self.wakeUpTimes.first(where: { $0.weekday.rawValue == weekday.rawValue }) {
            wakeUpObject.setWakeUpTime(wakeUpTime: wakeUpTime)
        }
    }
    
    override static func primaryKey() -> String? {
         return "_id"
    }
}

final class WakeUpTime: Object, Debuggable {
    let debug = true
    
    @Persisted var _id = ObjectId.generate()
    @Persisted private var weekdayInt: Int
    @Persisted var wakeUpTime: Date?
    
    var weekday: Weekday {
        get { return Weekday(rawValue: self.weekdayInt) ?? .unknown }
        set { self.weekdayInt = newValue.rawValue }
    }
    
    convenience init(weekday: Weekday, wakeUpTime: Date?) {
        self.init()
        self.weekday = weekday
        self.wakeUpTime = wakeUpTime
    }
    
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
