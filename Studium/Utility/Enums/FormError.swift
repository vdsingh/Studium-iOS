//
//  FormError.swift
//  Studium
//
//  Created by Vikram Singh on 1/31/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
enum FormError: String {
    case nameNotSpecified = "Please specify a name"
    case oneDayNotSpecified = "Please specify at least one day"
    case endTimeOccursBeforeStartTime = "End time cannot occur before start time"
    case totalTimeNotSpecified = "Please specify total time"
    
    case totalTimeExceedsTimeFrame = "The total time exceeds the time frame"
    
    static func constructErrorString(errors: [FormError]) -> String {
        let errorsString: String = errors
            .compactMap({ $0.rawValue })
            .joined(separator: ". ")
        return errorsString
    }
}
