//
//  AlertOption.swift
//  Studium
//
//  Created by Vikram Singh on 6/5/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

// TODO: Docstrings
enum AlertOption: Int, CaseIterable {
    case atTime = 0
    case fiveMin = 5
    case tenMin = 10
    case fifteenMin = 15
    case thirtyMin = 30
    case oneHour = 60
    case twoHour = 120
    case fourHour = 240
    case eightHour = 480
    case oneDay = 1440
    
    var userString: String {
        switch self {
        case .atTime:
            return "At time of event"
        case .fiveMin:
            return "5 minutes before"
        case .tenMin:
            return "10 minutes before"
        case .fifteenMin:
            return "15 minutes before"
        case .thirtyMin:
            return "30 minutes before"
        case .oneHour:
            return "1 hour before"
        case .twoHour:
            return "2 hours before"
        case .fourHour:
            return "4 hours before"
        case .eightHour:
            return "8 hours before"
        case .oneDay:
            return "1 day before"
        }
    }
}
