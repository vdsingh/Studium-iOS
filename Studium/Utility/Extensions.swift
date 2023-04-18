//
//  Event.swift
//  Studium
//
//  Created by Vikram Singh on 5/26/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import EventKit
import RealmSwift

extension String { //string extension for subscript access.
    var length: Int {
        return count
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

//date extension to get the next weekday of the week (i.e. next monday)
extension Date {
    
    var studiumWeekday: Weekday {
        Weekday(rawValue: self.weekday) ?? .unknown
    }
    
    //    static func today() -> Date {
    //        return Date()
    //    }
    //
    //    func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    //        return get(.next,
    //                   weekday,
    //                   considerToday: considerToday)
    //    }
    //
    //    func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    //        return get(.previous,
    //                   weekday,
    //                   considerToday: considerToday)
    //    }
    //
    //    func get(_ direction: SearchDirection,
    //             _ weekDay: Weekday,
    //             considerToday consider: Bool = false) -> Date {
    //
    //        let dayName = weekDay.rawValue
    //
    //        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }
    //
    //        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")
    //
    //        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1
    //
    //        let calendar = Calendar(identifier: .gregorian)
    //
    //        if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
    //            return self
    //        }
    //
    //        var nextDateComponent = calendar.dateComponents([.hour, .minute, .second], from: self)
    //        nextDateComponent.weekday = searchWeekdayIndex
    //
    //        let date = calendar.nextDate(after: self,
    //                                     matching: nextDateComponent,
    //                                     matchingPolicy: .nextTime,
    //                                     direction: direction.calendarSearchDirection)
    //
    //        return date!
    //    }
    
}

// MARK: Helper methods
extension Date {
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    
    enum SearchDirection {
        case next
        case previous
        
        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next:
                return .forward
            case .previous:
                return .backward
            }
        }
    }
}

//allows us to parse Strings for ints.
extension String {
    func parseToInt() -> Int? {
        return Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue: UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 60.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: min(red + percentage/100, 1.0),
                green: min(green + percentage/100, 1.0),
                blue: min(blue + percentage/100, 1.0),
                alpha: alpha
            )
        } else {
            return nil
        }
    }
}
