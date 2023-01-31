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
}
