//
//  FormError.swift
//  Studium
//
//  Created by Vikram Singh on 1/31/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

//TODO: Docstrings
enum StudiumFormError: FormError {
    case nameNotSpecified
    case oneDayNotSpecified
    case endTimeOccursBeforeStartTime
    case totalTimeNotSpecified
    case totalTimeExceedsTimeFrame
    case nameTooLong(charLimit: TextFieldCharLimit)
    case locationTooLong(charLimit: TextFieldCharLimit)
    case additionalDetailsTooLong(charLimit: TextFieldCharLimit)
    
    //TODO: Docstrings
    var stringRepresentation: String {
        switch self {
        case .nameNotSpecified:
            return "Please specify a name"
        case .oneDayNotSpecified:
            return "Please specify at least one day"
        case .endTimeOccursBeforeStartTime:
            return "End time cannot occur before start time"
        case .totalTimeNotSpecified:
            return "Please specify total time"
        case .totalTimeExceedsTimeFrame:
            return "The total time exceeds the time frame"
        case .nameTooLong(let charLimit):
            return "Please limit the name to \(charLimit.rawValue) characters"
        case .locationTooLong(let charLimit):
            return "Please limit the location to \(charLimit.rawValue) characters"
        case .additionalDetailsTooLong(let charLimit):
            return "Please limit the additional details to \(charLimit.rawValue) characters"
        }
    }
}
