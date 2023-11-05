//
//  UserSettings.swift
//  Studium
//
//  Created by Vikram Singh on 4/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

// TODO: Docstring
final class UserSettings: Object {

    // TODO: Docstrings
    @Persisted var _id = "UserSettings"
    // swiftlint:disable:previous identifier_name

    // TODO: Docstrings
    @Persisted private var _wakeUpMap: Map<String, Date>

    // TODO: Docstrings
    @Persisted private var defaultAlertOptionRawValues: List<Int>

    // TODO: Docstrings
    var wakeUpTimeMap: [Weekday: Date] {
        var dict = [Weekday: Date]()
        for wakeUpTime in self._wakeUpMap.keys {
            if let intValue = wakeUpTime.parseToInt(),
               let weekday = Weekday(rawValue: intValue) {
                dict[weekday] = _wakeUpMap[wakeUpTime]
            }
        }

        return dict
    }

    // TODO: Docstrings
    var defaultAlertOptions: Set<AlertOption> {
        return Set<AlertOption>(self.defaultAlertOptionRawValues.compactMap({ AlertOption(rawValue: $0) }))
    }

    // TODO: Docstrings
    func setDefaultAlertOptions(alertOptions: Set<AlertOption>) {
        self.defaultAlertOptionRawValues = List<Int>()
        for option in alertOptions {
            self.defaultAlertOptionRawValues.append(option.rawValue)
        }
    }

    override static func primaryKey() -> String? {
         return "_id"
    }
}

// MARK: - Wake Up Time
extension UserSettings {

    // TODO: Docstrings
    func getWakeUpTime(for date: Date) -> Date? {
        let time = self.getWakeUpTime(for: date.weekdayValue)
        return time?.setDate(year: date.year, month: date.month, day: date.day)
    }

    // TODO: Docstrings
    private func getWakeUpTime(for weekday: Weekday) -> Date? {
        return self.wakeUpTimeMap[weekday]
    }

    // TODO: Docstrings
    func setWakeUpTime(for weekday: Weekday, wakeUpTime: Date) {
        let stringValue = "\(weekday.rawValue)"
        self._wakeUpMap[stringValue] = wakeUpTime
    }
}
