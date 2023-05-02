//
//  MockAutoscheduleService.swift
//  Studium
//
//  Created by Vikram Singh on 5/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation


class MockAutoscheduleService: AutoscheduleServiceProtocol {
    static let shared = MockAutoscheduleService()
    
    private init() { }
    
    func autoscheduleEvent(event: StudiumEvent, date: Date) {
        
    }
    
    func getCommitments(for date: Date) -> [TimeChunk] {
        return []
    }
    
    func getOpenTimeSlots(startBound: Date, endBound: Date, commitments: [TimeChunk]) -> [TimeChunk] {
        return []
    }
    
    func bestTime(openTimeSlots: [TimeChunk], totalMinutes: Int) -> TimeChunk? {
        return nil
    }
    
    func findAutoscheduleTimeChunk(dateToScheduleOn: Date, startBound: Date, endBound: Date, totalMinutes: Int) -> TimeChunk? {
        return nil
    }
    
    func findAllApplicableDatesBetween(startDate: Date, endDate: Date, weekdays: Set<Weekday>) -> [Date] {
        return []
    }
    
    func autoscheduleStudyTime(parentAssignment: Assignment) {
        
    }
}
