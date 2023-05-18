//
//  Date_Extension.swift
//  Studium
//
//  Created by Vikram Singh on 5/3/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//
//
//import Foundation
//
//extension Date {
//    
//    /// Gets the weekday of the Date as a Weekday type
//    var studiumWeekday: Weekday {
//        Weekday(rawValue: self.weekday) ?? .unknown
//    }
//    
//    /// The start of the Date
//    var startOfDay: Date {
//        return Calendar.current.startOfDay(for: self)
//    }
//    
//    /// The end of the Date
//    var endOfDay: Date {
//        var components = DateComponents()
//        components.day = 1
//        components.second = -1
//        return Calendar.current.date(byAdding: components, to: startOfDay)!
//    }
//    
//    /// An arbitrary Monday (5/1/23)
//    static var someMonday: Date {
//        Date(year: 2023, month: 5, day: 1)
//    }
//    
//    /// An arbitrary Tuesday (5/2/23)
//    static var someTuesday: Date {
//        Date(year: 2023, month: 5, day: 2)
//    }
//    
//    /// An arbitrary Wednesday (5/3/23)
//    static var someWednesday: Date {
//        Date(year: 2023, month: 5, day: 3)
//    }
//    
//    /// An arbitrary Thursday (5/4/23)
//    static var someThursday: Date {
//        Date(year: 2023, month: 5, day: 4)
//    }
//    
//    /// An arbitrary Friday (5/5/23)
//    static var someFriday: Date {
//        Date(year: 2023, month: 5, day: 5)
//    }
//    
//    /// An arbitrary Saturday (5/6/23)
//    static var someSaturday: Date {
//        Date(year: 2023, month: 5, day: 6)
//    }
//    
//    /// An arbitrary Sunday (5/7/23)
//    static var someSunday: Date {
//        Date(year: 2023, month: 5, day: 7)
//    }
//    
//    
//    /// Gets a (pseudo) random Date for a given Weekday
//    /// - Parameter weekday: The Weekday that we want the random Date for
//    /// - Returns: A (pseudo) random Date for a given Weekday
//    static func random(weekday: Weekday) -> Date {
//        var currentDate = Date()
//        while currentDate.studiumWeekday != weekday {
//            currentDate = currentDate.add(days: 1)
//        }
//        
//        var randomDaysToAdd = Int.random(in: -20...20) * 7
//        currentDate = currentDate.add(days: randomDaysToAdd)
//
//        return currentDate
//    }
//    
//    /// Determines whether a given Date occurs at the same time as this date (hour, minute)
//    /// - Parameter date: The Date that we are checking
//    /// - Returns: A Bool describing whether the Date occurs at the same time
//    func occursAtTheSameTimeAs(_ date: Date) -> Bool {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.hour, .minute], from: self)
//        let otherComponents = calendar.dateComponents([.hour, .minute], from: date)
//        
//        return components.hour == otherComponents.hour && components.minute == otherComponents.minute
//    }
//    
//    /// Whether or not a given date occurs on the same day, month, and year
//    /// - Parameter date: The date that we're checking
//    /// - Returns: Whether or not the event occurs on the date
//    func occursOn(date: Date) -> Bool {
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([.day, .month, .year], from: self)
//        let otherComponents = calendar.dateComponents([.day, .month, .year], from: date)
//        
//        return components.day == otherComponents.day && components.month == otherComponents.month && components.year == otherComponents.year
//    }
//    
//    //TODO: Docstrings
//    func getWeekDaysInEnglish() -> [String] {
//        var calendar = Calendar(identifier: .gregorian)
//        calendar.locale = Locale(identifier: "en_US_POSIX")
//        return calendar.weekdaySymbols
//    }
//    
//    //TODO: Docstrings
//    func setTime(hour: Int, minute: Int, second: Int) -> Date? {
//        let calendar = Calendar(identifier: .gregorian)
//        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
//        dateComponents.hour = hour
//        dateComponents.minute = minute
//        dateComponents.second = second
//        return calendar.date(from: dateComponents)
//    }
//    
//    //TODO: Docstrings
//    func setDate(year: Int, month: Int, day: Int) -> Date? {
//        let calendar = Calendar(identifier: .gregorian)
//        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
//        dateComponents.year = year
//        dateComponents.month = month
//        dateComponents.day = day
//        return calendar.date(from: dateComponents)
//    }
//    
//    
//    //TODO: Docstrings
//    func subtract(minutes: Int) -> Date {
//        return Calendar.current.date(byAdding: .minute, value: -minutes, to: self)!
//    }
//    
//    /// Returns a Date with a given number of minutes added to this Date
//    /// - Parameter minutes: The number of minutes to add to this Date
//    /// - Returns: A Date with a given number of minutes added to this Date
//    func add(minutes: Int) -> Date {
//        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
//    }
//    
//    /// Returns a Date with a given number of hours added to this Date
//    /// - Parameter hours: The number of hours to add to this Date
//    /// - Returns: A Date with a given number of hours added to this Date
//    func add(hours: Int) -> Date {
//        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
//    }
//    
//    /// Returns a Date with a given number of days added to this Date
//    /// - Parameter days: The number of days to add to this Date
//    /// - Returns: A Date with a given number of days added to this Date
//    func add(days: Int) -> Date {
//        return Calendar.current.date(byAdding: .day, value: days, to: self)!
//    }
//}
