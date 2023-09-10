//
//  Date_Extension.swift
//  
//
//  Created by Vikram Singh on 5/14/23.
//

import Foundation

public extension Date {
    
    /// Gets the weekday of the Date as a Weekday type
    var weekdayValue: Weekday {
        Weekday(rawValue: self.weekday) ?? .unknown
    }
    
    /// The start of the Date
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    /// The end of the Date
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: self.startOfDay)!
    }
    
    /// An arbitrary Monday (5/1/23)
    static var someMonday: Date {
        Date(year: 2023, month: 5, day: 1)
    }
    
    /// An arbitrary Tuesday (5/2/23)
    static var someTuesday: Date {
        Date(year: 2023, month: 5, day: 2)
    }
    
    /// An arbitrary Wednesday (5/3/23)
    static var someWednesday: Date {
        Date(year: 2023, month: 5, day: 3)
    }
    
    /// An arbitrary Thursday (5/4/23)
    static var someThursday: Date {
        Date(year: 2023, month: 5, day: 4)
    }
    
    /// An arbitrary Friday (5/5/23)
    static var someFriday: Date {
        Date(year: 2023, month: 5, day: 5)
    }
    
    /// An arbitrary Saturday (5/6/23)
    static var someSaturday: Date {
        Date(year: 2023, month: 5, day: 6)
    }
    
    /// An arbitrary Sunday (5/7/23)
    static var someSunday: Date {
        Date(year: 2023, month: 5, day: 7)
    }
    
    
    /// Gets a (pseudo) random Date for a given Weekday
    /// - Parameter weekday: The Weekday that we want the random Date for
    /// - Returns: A (pseudo) random Date for a given Weekday
    static func random(weekday: Weekday) -> Date {
        var currentDate = Date()
        while currentDate.weekdayValue != weekday {
            currentDate = currentDate.add(days: 1)
        }
        
        var randomDaysToAdd = Int.random(in: -20...20) * 7
        currentDate = currentDate.add(days: randomDaysToAdd)

        return currentDate
    }
    
    /// Determines whether a given Date occurs at the same time as this date (hour, minute)
    /// - Parameter date: The Date that we are checking
    /// - Returns: A Bool describing whether the Date occurs at the same time
    func occursAtTheSameTimeAs(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: self)
        let otherComponents = calendar.dateComponents([.hour, .minute], from: date)
        
        return components.hour == otherComponents.hour && components.minute == otherComponents.minute
    }
    
    /// Whether or not a given date occurs on the same day, month, and year
    /// - Parameter date: The date that we're checking
    /// - Returns: Whether or not the event occurs on the date
    func occursOn(date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: self)
        let otherComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        return components.day == otherComponents.day && components.month == otherComponents.month && components.year == otherComponents.year
    }
    
    //TODO: Docstrings
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    //TODO: Docstrings
    func setTime(hour: Int, minute: Int, second: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        return calendar.date(from: dateComponents)
    }
    
    //TODO: Docstrings
    func setDate(year: Int, month: Int, day: Int) -> Date? {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        return calendar.date(from: dateComponents)
    }
    
    
    //TODO: Docstrings
    func subtract(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: -minutes, to: self)!
    }
    
    /// Returns a Date with a given number of minutes added to this Date
    /// - Parameter minutes: The number of minutes to add to this Date
    /// - Returns: A Date with a given number of minutes added to this Date
    func add(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    /// Returns a Date with a given number of hours added to this Date
    /// - Parameter hours: The number of hours to add to this Date
    /// - Returns: A Date with a given number of hours added to this Date
    func add(hours: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: hours, to: self)!
    }
    
    /// Returns a Date with a given number of days added to this Date
    /// - Parameter days: The number of days to add to this Date
    /// - Returns: A Date with a given number of days added to this Date
    func add(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }

    /**
     *  Convenient accessor of the date's `Calendar` components.
     *
     *  - parameter component: The calendar component to access from the date
     *
     *  - returns: The value of the component
     *
     */
    func component(_ component: Calendar.Component) -> Int {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.component(component, from: self)
    }
    
    /**
     *  Convenient accessor of the date's `Calendar` components ordinality.
     *
     *  - parameter smaller: The smaller calendar component to access from the date
     *  - parameter larger: The larger calendar component to access from the date
     *
     *  - returns: The ordinal number of a smaller calendar component within a specified larger calendar component
     *
     */
    func ordinality(of smaller: Calendar.Component, in larger: Calendar.Component) -> Int? {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.ordinality(of: smaller, in: larger, for: self)
    }
    
    /**
     *  Use calendar components to determine how many units of a smaller component are inside 1 larger unit.
     *
     *  Ex. If used on a date in the month of February in a leap year (regardless of the day), the method would
     *  return 29 days.
     *
     *  - parameter smaller: The smaller calendar component to access from the date
     *  - parameter larger: The larger calendar component to access from the date
     *
     *  - returns: The number of smaller units required to equal in 1 larger unit, given the date called on
     *
     */
    @available(*, deprecated, message: "Calendar component hashes no longer yield relevant values and will always return nil. The function is deprecated and will be removed soon.")
    func unit(of smaller: Calendar.Component, in larger: Calendar.Component) -> Int? {
        let calendar = Calendar.autoupdatingCurrent
        var units = 1
        var unitRange: Range<Int>?
        if larger.hashValue < smaller.hashValue {
            for x in larger.hashValue..<smaller.hashValue {
                
                var stepLarger: Calendar.Component
                var stepSmaller: Calendar.Component
                
                switch(x) {
                case 0:
                    stepLarger = Calendar.Component.era
                    stepSmaller = Calendar.Component.year
                    unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    break
                case 1:
                    if smaller.hashValue > 2 {
                        break
                    } else {
                        stepLarger = Calendar.Component.year
                        stepSmaller = Calendar.Component.month
                        unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    }
                    break
                case 2:
                    if larger.hashValue < 2 {
                        if self.isInLeapYear {
                            unitRange = Range.init(uncheckedBounds: (lower: 0, upper: 366))
                        } else {
                            unitRange = Range.init(uncheckedBounds: (lower: 0, upper: 365))
                        }
                    } else {
                        stepLarger = Calendar.Component.month
                        stepSmaller = Calendar.Component.day
                        unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    }
                    break
                case 3:
                    stepLarger = Calendar.Component.day
                    stepSmaller = Calendar.Component.hour
                    unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    break
                case 4:
                    stepLarger = Calendar.Component.hour
                    stepSmaller = Calendar.Component.minute
                    unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    break
                case 5:
                    stepLarger = Calendar.Component.minute
                    stepSmaller = Calendar.Component.second
                    unitRange = calendar.range(of: stepSmaller, in: stepLarger, for: self)
                    break
                default:
                    return nil
                }
                
                if unitRange?.count != nil {
                    units *= (unitRange?.count)!
                }
            }
            return units
        }
        return nil
    }
    
    // MARK: - Components
    
    /**
     *  Convenience getter for the date's `era` component
     */
    var era: Int {
        return component(.era)
    }
    
    /**
     *  Convenience getter for the date's `year` component
     */
    var year: Int {
        return component(.year)
    }
    
    /**
     *  Convenience getter for the date's `month` component
     */
    var month: Int {
        return component(.month)
    }
    
    /**
     *  Convenience getter for the date's `week` component
     */
    var week: Int {
        return component(.weekday)
    }
    
    /**
     *  Convenience getter for the date's `day` component
     */
    var day: Int {
        return component(.day)
    }
    
    /**
     *  Convenience getter for the date's `hour` component
     */
    var hour: Int {
        return component(.hour)
    }
    
    /**
     *  Convenience getter for the date's `minute` component
     */
    var minute: Int {
        return component(.minute)
    }
    
    /**
     *  Convenience getter for the date's `second` component
     */
    var second: Int {
        return component(.second)
    }
    
    /**
     *  Convenience getter for the date's `weekday` component
     */
    var weekday: Int {
        return component(.weekday)
    }
    
    /**
     *  Convenience getter for the date's `weekdayOrdinal` component
     */
    var weekdayOrdinal: Int {
        return component(.weekdayOrdinal)
    }
    
    /**
     *  Convenience getter for the date's `quarter` component
     */
    var quarter: Int {
        return component(.quarter)
    }
    
    /**
     *  Convenience getter for the date's `weekOfYear` component
     */
    var weekOfMonth: Int {
        return component(.weekOfMonth)
    }
    
    /**
     *  Convenience getter for the date's `weekOfYear` component
     */
    var weekOfYear: Int {
        return component(.weekOfYear)
    }
    
    /**
     *  Convenience getter for the date's `yearForWeekOfYear` component
     */
    var yearForWeekOfYear: Int {
        return component(.yearForWeekOfYear)
    }
    
    /**
     *  Convenience getter for the date's `daysInMonth` component
     */
    var daysInMonth: Int {
        let calendar = Calendar.autoupdatingCurrent
        let days = calendar.range(of: .day, in: .month, for: self)
        return days!.count
    }
    
    // MARK: - Set Components
    
    /**
     *  Convenience setter for the date's `year` component
     */
    mutating func year(_ year: Int) {
        self = Date.init(year: year, month: self.month, day: self.day, hour: self.hour, minute: self.minute, second: self.second)
    }
    
    /**
     *  Convenience setter for the date's `month` component
     */
    mutating func month(_ month: Int) {
        self = Date.init(year: self.year, month: month, day: self.day, hour: self.hour, minute: self.minute, second: self.second)
    }
    
    /**
     *  Convenience setter for the date's `day` component
     */
    mutating func day(_ day: Int) {
        self = Date.init(year: self.year, month: self.month, day: day, hour: self.hour, minute: self.minute, second: self.second)
    }
    
    /**
     *  Convenience setter for the date's `hour` component
     */
    mutating func hour(_ hour: Int) {
        self = Date.init(year: self.year, month: self.month, day: self.day, hour: hour, minute: self.minute, second: self.second)
    }
    
    /**
     *  Convenience setter for the date's `minute` component
     */
    mutating func minute(_ minute: Int) {
        self = Date.init(year: self.year, month: self.month, day: self.day, hour: self.hour, minute: minute, second: self.second)
    }
    
    /**
     *  Convenience setter for the date's `second` component
     */
    mutating func second(_ second: Int) {
        self = Date.init(year: self.year, month: self.month, day: self.day, hour: self.hour, minute: self.minute, second: second)
    }
    
    
    // MARK: - Bools
    
    /**
     *  Determine if date is in a leap year
     */
    var isInLeapYear: Bool {
        let yearComponent = component(.year)
        
        if yearComponent % 400 == 0 {
            return true
        }
        if yearComponent % 100 == 0 {
            return false
        }
        if yearComponent % 4 == 0 {
            return true
        }
        return false
    }
    
    /**
     *  Determine if date is within the current day
     */
    var isToday: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInToday(self)
    }
    
    /**
     *  Determine if date is within the day tomorrow
     */
    var isTomorrow: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInTomorrow(self)
    }
    
    /**
     *  Determine if date is within yesterday
     */
    var isYesterday: Bool {
        let calendar = Calendar.autoupdatingCurrent
        return calendar.isDateInYesterday(self)
    }
    
    /**
     *  Determine if date is in a weekend
     */
    var isWeekend: Bool {
        if weekday == 7 || weekday == 1 {
            return true
        }
        return false
    }

    // MARK: - Initializers
    
    /**
     *  Init date with components.
     *
     *  - parameter year: Year component of new date
     *  - parameter month: Month component of new date
     *  - parameter day: Day component of new date
     *  - parameter hour: Hour component of new date
     *  - parameter minute: Minute component of new date
     *  - parameter second: Second component of new date
     */
    init(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second
        
        guard let date = Calendar.current.date(from: dateComponents) else {
            self = Date()
            return
        }
        self = date
    }
    
    /**
     *  Init date with components. Hour, minutes, and seconds set to zero.
     *
     *  - parameter year: Year component of new date
     *  - parameter month: Month component of new date
     *  - parameter day: Day component of new date
     */
    init(year: Int, month: Int, day: Int) {
        self.init(year: year, month: month, day: day, hour: 0, minute: 0, second: 0)
    }
    
    /**
     *  Init date from string, given a format string, according to Apple's date formatting guide, and time zone.
     *
     *  - parameter dateString: Date in the formatting given by the format parameter
     *  - parameter format: Format style using Apple's date formatting guide
     *  - parameter timeZone: Time zone of date
     */
    init(dateString: String, format: String, timeZone: TimeZone) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none;
        dateFormatter.timeStyle = .none;
        dateFormatter.timeZone = timeZone;
        dateFormatter.dateFormat = format;
        
        guard let date = dateFormatter.date(from: dateString) else {
            self = Date()
            return
        }
        self = date
    }
    
    /**
     *  Init date from string, given a format string, according to Apple's date formatting guide.
     *  Time Zone automatically selected as the current time zone.
     *
     *  - parameter dateString: Date in the formatting given by the format parameter
     *  - parameter format: Format style using Apple's date formatting guide
     */
    init (dateString: String, format: String) {
        self.init(dateString: dateString, format: format, timeZone: TimeZone.autoupdatingCurrent)
    }

    // MARK: - Formatted Date - Style
    
    /**
     *  Get string representation of date.
     *
     *  - parameter dateStyle: The date style in which to represent the date
     *  - parameter timeZone: The time zone of the date
     *  - parameter locale: Encapsulates information about linguistic, cultural, and technological conventions and standards
     *
     *  - returns: Represenation of the date (self) in the specified format
     */
    func format(with dateStyle: DateFormatter.Style, timeZone: TimeZone, locale: Locale) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = dateStyle
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        
        return dateFormatter.string(from: self)
    }
    
    /**
     *  Get string representation of date. Locale is automatically selected as the current locale of the system.
     *
     *  - parameter dateStyle: The date style in which to represent the date
     *  - parameter timeZone: The time zone of the date
     *
     *  - returns String? - Represenation of the date (self) in the specified format
     */
    func format(with dateStyle: DateFormatter.Style, timeZone: TimeZone) -> String {
        #if os(Linux)
            return format(with: dateStyle, timeZone: timeZone, locale: Locale.current)
        #else
            return format(with: dateStyle, timeZone: timeZone, locale: Locale.autoupdatingCurrent)
        #endif
    }
    
    /**
     *  Get string representation of date.
     *  Time zone is automatically selected as the current time zone of the system.
     *
     *  - parameter dateStyle: The date style in which to represent the date
     *  - parameter locale: Encapsulates information about linguistic, cultural, and technological conventions and standards.
     *
     *  - returns: Represenation of the date (self) in the specified format
     */
    func format(with dateStyle: DateFormatter.Style, locale: Locale) -> String {
        return format(with: dateStyle, timeZone: TimeZone.autoupdatingCurrent, locale: locale)
    }
    
    /**
     *  Get string representation of date.
     *  Locale and time zone are automatically selected as the current locale and time zone of the system.
     *
     *  - parameter dateStyle: The date style in which to represent the date
     *
     *  - returns: Represenation of the date (self) in the specified format
     */
    func format(with dateStyle: DateFormatter.Style) -> String {
        #if os(Linux)
            return format(with: dateStyle, timeZone: TimeZone.autoupdatingCurrent, locale: Locale.current)
        #else
            return format(with: dateStyle, timeZone: TimeZone.autoupdatingCurrent, locale: Locale.autoupdatingCurrent)
        #endif
    }
    
    
    // MARK: - Formatted Date - String
    
    /**
     *  Get string representation of date.
     *
     *  - parameter dateFormat: The date format string, according to Apple's date formatting guide in which to represent the date
     *  - parameter timeZone: The time zone of the date
     *  - parameter locale: Encapsulates information about linguistic, cultural, and technological conventions and standards
     *
     *  - returns: Represenation of the date (self) in the specified format
     */
    func format(with dateFormat: String, timeZone: TimeZone, locale: Locale) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        
        return dateFormatter.string(from: self)
    }
    
    /**
     *  Get string representation of date.
     *  Locale is automatically selected as the current locale of the system.
     *
     *  - parameter dateFormat: The date format string, according to Apple's date formatting guide in which to represent the date
     *  - parameter timeZone: The time zone of the date
     *
     *  - returns: Representation of the date (self) in the specified format
     */
    func format(with dateFormat: String, timeZone: TimeZone) -> String {
        #if os(Linux)
            return format(with: dateFormat, timeZone: timeZone, locale: Locale.current)
        #else
            return format(with: dateFormat, timeZone: timeZone, locale: Locale.autoupdatingCurrent)
        #endif
    }
    
    /**
     *  Get string representation of date.
     *  Time zone is automatically selected as the current time zone of the system.
     *
     *  - parameter dateFormat: The date format string, according to Apple's date formatting guide in which to represent the date
     *  - parameter locale: Encapsulates information about linguistic, cultural, and technological conventions and standards
     *
     *  - returns: Represenation of the date (self) in the specified format
     */
    func format(with dateFormat: String, locale: Locale) -> String {
        return format(with: dateFormat, timeZone: TimeZone.autoupdatingCurrent, locale: locale)
    }
    
    /**
     *  Get string representation of date.
     *  Locale and time zone are automatically selected as the current locale and time zone of the system.
     *
     *  - parameter dateFormat: The date format string, according to Apple's date formatting guide in which to represent the date
     *
     *  - returns: Represenation of the date (self) in the specified format
     */
    func format(with dateFormat: String) -> String {
        #if os(Linux)
            return format(with: dateFormat, timeZone: TimeZone.autoupdatingCurrent, locale: Locale.current)
        #else
            return format(with: dateFormat, timeZone: TimeZone.autoupdatingCurrent, locale: Locale.autoupdatingCurrent)
        #endif
    }
}
