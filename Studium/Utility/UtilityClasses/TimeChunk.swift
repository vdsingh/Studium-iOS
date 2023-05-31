//
//  TimeChunk.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

//TODO: Docstrings
class TimeChunk {
    
    //TODO: Docstrings
    let startDate: Date
    
    //TODO: Docstrings
    let endDate: Date
    
    //TODO: Docstrings
    let descriptor: String?
    
    //TODO: Docstrings
    var lengthInMinutes: Int {
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: startDate, to: endDate)
        return diffComponents.minute ?? 0
    }
    
    //TODO: Docstrings
    var midpoint: Date {
        return startDate.addingTimeInterval(endDate.timeIntervalSince(startDate) / 2)
    }
    
    //TODO: Docstrings
    init(startDate: Date, endDate: Date, descriptor: String? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        self.descriptor = descriptor
    }
}
