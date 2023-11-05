//
//  Date+Time.swift
//  Studium
//
//  Created by Vikram Singh on 9/27/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
extension Date {
    var time: Time {
        return Time(hour: self.hour, minute: self.minute)
    }
}
