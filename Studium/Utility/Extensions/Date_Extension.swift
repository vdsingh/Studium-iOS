//
//  Date_Extension.swift
//  Studium
//
//  Created by Vikram Singh on 5/3/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//
//
import Foundation

extension Date {
    static func datesWithinThreeMonths(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        
        guard let threeMonthsLater = calendar.date(byAdding: .month, value: 3, to: date1),
              let threeMonthsEarlier = calendar.date(byAdding: .month, value: -3, to: date1)
        else {
            return false
        }
        
        return date2 >= threeMonthsEarlier && date2 <= threeMonthsLater
    }
    
    var daysHoursMinsDueDateString: String {
        let (days, hours, mins) = Date().daysMinsHours(until: self)
        return "in \(days) Days, \(hours) Hours, \(mins) Minutes"
    }
    
    func daysMinsHours(until date: Date) -> (days: Int, hours: Int, minutes: Int) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .hour, .minute], from: self, to: date)
        let days = components.day ?? 0
        let hours = components.hour ?? 0
        let minutes = components.minute ?? 0
        
        return (days, hours, minutes)
    }
}
