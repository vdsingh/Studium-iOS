//
//  AutoscheduleService.swift
//  Studium
//
//  Created by Vikram Singh on 4/18/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

//TODO: Docstrings
protocol AutoscheduleServiceProtocol {
    func createAutoscheduledEvents<T: Autoscheduling>(forAutoschedulingEvent event: T, completion: @escaping ([T.AutoscheduledEventType]) -> Void)
    //    func getCommitments(for date: Date) -> [StudiumEvent: TimeChunk]
    //    func getOpenTimeSlots(startBound: Date, endBound: Date, commitments: [TimeChunk]) -> [TimeChunk]
    //    func bestTime(openTimeSlots: [TimeChunk], totalMinutes: Int) -> TimeChunk?
    //    func findAllApplicableDatesBetween(startDate: Date, endDate: Date, weekdays: Set<Weekday>) -> [Date]
}

extension Date {
    var threeMonthsLater: Date {
        return self.add(days: 90)
    }
}

/// Handles any autoscheduling logic
final class AutoscheduleService: NSObject {
    
    static let shared = AutoscheduleService()
    
    /// Calculates time slots for autoscheduling events
    /// - Parameters:
    ///   - config:     The configuration that specifies how events should be scheduled
    ///   - completion: Completion handler with the TimeChunks for the time slots
    func findAutoschedulingTimeSlots(forConfig config: AutoschedulingConfig,
                                     completion: @escaping ([(Date, TimeChunk)]) -> Void) {
        
        let startDateBound = config.startDateBound.endOfDay
        let endDateBound = config.endDateBound?.endOfDay ?? startDateBound.threeMonthsLater.endOfDay
        
        let applicableDates = self.findAllApplicableDatesBetween(startDate: startDateBound,
                                                                 endDate: endDateBound,
                                                                 weekdays: config.autoschedulingDays)
        var timeSlots = [(Date, TimeChunk)]()
        for date in applicableDates {
            let commitments = [TimeChunk]()
            let openTimeSlots = self.findOpenTimeSlots(commitments: commitments,
                                                       startTimeBound: config.startTimeBound,
                                                       endTimeBound: config.endTimeBound,
                                                       minLengthMinutes: config.autoLengthMinutes)
            let bestTimeSlot = openTimeSlots[openTimeSlots.count / 2]
            timeSlots.append((date, bestTimeSlot))
        }
        
        completion(timeSlots)
    }

    /// Finds all open time slots that are greater than a specified length
    /// - Parameters:
    ///   - commitments:      The commitments to find slots around
    ///   - startTimeBound:   The earliest that open time slots can occur
    ///   - endTimeBound:     The latest that open time slots can occur
    ///   - minLengthMinutes: The minimum length of time slots in minutes
    /// - Returns: An array of applicable TimeChunks representing open slots
    func findOpenTimeSlots(commitments: [TimeChunk],
                           startTimeBound: Time,
                           endTimeBound: Time,
                           minLengthMinutes: Int) -> [TimeChunk] {
        if startTimeBound > endTimeBound {
            Log.e("startTimeBound is after endTimeBound.")
            return []
        }
        
        // Turn start bound and end bound into commitments themselves to simplify
        let startCommitment = TimeChunk(startTime: .init(hour: 0, minute: 0), endTime: startTimeBound)
        let endCommitment = TimeChunk(startTime: endTimeBound, endTime: .init(hour: 23, minute: 59))

        var commitmentsWithBounds: [TimeChunk] = [startCommitment, endCommitment]
        commitmentsWithBounds.append(contentsOf: commitments)
        
        let sortedCommitments = commitmentsWithBounds.sorted { $0.startTime < $1.startTime }
        var openSlots = [TimeChunk]()
        var currentBound = Time.startOfDay

        for commitment in sortedCommitments {
            // If there's an open slot between the currentBound and the next commitment's startTime
            if commitment.startTime > currentBound {
                openSlots.append(TimeChunk(startTime: currentBound, endTime: commitment.startTime))
            }
            // If the next commitment's endTime is later than the current bound
            if commitment.endTime > currentBound {
                currentBound = commitment.endTime
            }
        }
        
        // If the last commitment doesn't end at endBound, then add the remaining time as an open slot.
        if currentBound < endTimeBound {
            openSlots.append(TimeChunk(startTime: currentBound, endTime: endTimeBound))
        }

        return openSlots.filter { $0.lengthInMinutes >= minLengthMinutes }
    }
    
    ///Finds the best time  event given the event's length in minutes and the open time slots. It does this by finding the longest open time slot and planning the event in the middle of it .
    ///
    /// - Parameters:
    ///     - openTimeSlots: the time slots available in the day. This is usually calculated by the getOpenTimeSlots function
    ///     - totalMinutes: the total length in minutes of the event we are scheduling
    /// - Returns: an array containing the start time and the end time of the event.
//    private func bestTime(openTimeSlots: [TimeChunk], totalMinutes: Int) -> TimeChunk? {
//        var bestTimeSlot: TimeChunk? = nil
//        for openTimeSlot in openTimeSlots {
//            
//            // Our event can fit in the slot
//            if openTimeSlot.lengthInMinutes >= totalMinutes {
//                if let bestTimeSlotSafe = bestTimeSlot {
//                    // This is the biggest working slot we have seen so far
//                    if openTimeSlot.lengthInMinutes > bestTimeSlotSafe.lengthInMinutes {
//                        bestTimeSlot = openTimeSlot
//                    }
//                } else {
//                    bestTimeSlot = openTimeSlot
//                }
//            }
//        }
//        
//        // If there is a best time slot, take its midpoint and return a TimeChunk in the middle that is the events length
//        if let bestTimeSlot = bestTimeSlot {
//            let midpoint = bestTimeSlot.midpoint
//            // FIXME: 
//            return TimeChunk(startTime: Time(hour: 1, minute: 0), endTime: Time(hour: 2, minute: 0))
////            return TimeChunk(startTime: midpoint.subtract(minutes: totalMinutes / 2),
////                             endTime: midpoint.add(minutes: totalMinutes / 2))
//        }
//        
//        return nil
//    }
    
    /// Finds all of the dates for certain weekdays between two dates
    /// - Parameters:
    ///   - startDate: The start bound for the range
    ///   - endDate: The end bound for the range
    ///   - weekdays: The days that we're looking for
    /// - Returns: An array of Date objects which represent applicable days
    func findAllApplicableDatesBetween(
        startDate: Date,
        endDate: Date,
        weekdays: Set<Weekday>
    ) -> [Date] {
        let startDate = startDate.endOfDay
        let endDate = endDate.endOfDay
        
        var resultDates = [Date]()
        let calendar = Calendar.current
        
        // Iterate through each day in the range
        var currentDate = startDate
        while currentDate <= endDate {
            
            // Move to the next day
            if weekdays.contains(currentDate.weekdayValue) {
                resultDates.append(currentDate)
            }
            
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return resultDates
    }
}

/// Errors that may occur in AutoscheduleService
enum AutoscheduleServiceError: Error {
    case triedToAutoscheduleForNonAutoschedulingEvent
}
