//
//  GoogleAuthScope.swift
//  Studium
//
//  Created by Vikram Singh on 6/23/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

enum GoogleAuthScope {
    case calendarAPI
    
    var scopeURLString: String {
        switch self {
        case .calendarAPI:
            return "https://www.googleapis.com/auth/calendar"
        }
    }
}
