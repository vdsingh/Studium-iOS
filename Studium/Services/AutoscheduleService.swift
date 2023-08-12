//
//  AutoscheduleService.swift
//  Studium
//
//  Created by Vikram Singh on 4/18/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import VikUtilityKit
import RealmSwift

//TODO: Docstrings
protocol AutoscheduleServiceProtocol {
    func createAutoscheduledEvents<T: Autoscheduling>(forAutoschedulingEvent event: T, completion: @escaping ([T.AutoscheduledEventType]) -> Void)
    //    func getCommitments(for date: Date) -> [StudiumEvent: TimeChunk]
    //    func getOpenTimeSlots(startBound: Date, endBound: Date, commitments: [TimeChunk]) -> [TimeChunk]
    //    func bestTime(openTimeSlots: [TimeChunk], totalMinutes: Int) -> TimeChunk?
    //    func findAllApplicableDatesBetween(startDate: Date, endDate: Date, weekdays: Set<Weekday>) -> [Date]
}

//TODO: Docstrings
final class AutoscheduleService: NSObject, AutoscheduleServiceProtocol, Debuggable {
    
    var debug = true
    
    //TODO: Docstrings
    let databaseService: DatabaseService
    
    static let shared = AutoscheduleService(databaseService: DatabaseService.shared)
    
    //TODO: Docstrings
    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }
    
    func createAutoscheduledEvents<T: Autoscheduling>(
        forAutoschedulingEvent event: T,
        completion: @escaping ([T.AutoscheduledEventType]) -> Void
    ) {
        Log.d("createAutoscheduledEvents called for event \(event.name)")
        if !event.autoscheduling {
            Log.s(AutoscheduleServiceError.triedToAutoscheduleForNonAutoschedulingEvent, additionalDetails: "autoscheduleEvent was called for event \(event) although the event is not autoscheduling.")
            completion([])
        }
        
        let startDate = Date()
        var endDate = event.endDate
        
        // if autoschedule infinitely, autoschedule to 3 months from startDate, otherwise, schedule to event endDate
        if event.autoscheduleInfinitely || !Date.datesWithinThreeMonths(date1: Date(), date2: event.endDate) {
            endDate = Calendar.current.date(byAdding: .month, value: 3, to: Date())!
            PopUpService.shared.presentToast(title: "Autoscheduled \(event.name)", description: "We'll autoschedule events for \(event.name) for the next three months.", popUpType: .success)
        }
        
        let eventID = event._id.stringValue
        
        // Run the algorithm on background thread
        DispatchQueue.global().async {
            guard let event = self.databaseService.getStudiumEvent(withPrimaryKey: eventID, type: T.self) else {
                return
            }
            
            let applicableDates = self.findAllApplicableDatesBetween(
                startDate: startDate,
                endDate: endDate,
                weekdays: event.autoschedulingDays
            )
            
            Log.d("the applicable dates between \(startDate) and \(endDate) for event \(event.name) are \(applicableDates)")
            var autoscheduledEvents = [T.AutoscheduledEventType]()
            
            for date in applicableDates {
                // Start Bound of the day (usually wake up time)
                var startBound = self.databaseService.getUserSettings().getWakeUpTime(for: date) ?? date.startOfDay
                var endBound = date.endOfDay
                
                if event.useDatesAsBounds {
                    startBound = event.startDate.setDate(year: date.year, month: date.month, day: date.day)!
                    endBound = event.endDate.setDate(year: date.year, month: date.month, day: date.day)!
                }
                
                // Array of TimeChunks representing commitments for the day
                let commitments = [TimeChunk](self.getCommitments(for: date).values)
                
                // Open time slots for the day
                let openTimeSlots = self.getOpenTimeSlots(
                    startBound: startBound,
                    endBound: endBound,
                    commitments: commitments
                )
                
                // find the best TimeChunk for the event, if one exists
                if let bestTimeChunk = self.bestTime(
                    openTimeSlots: openTimeSlots,
                    totalMinutes: event.autoLengthMinutes
                ) {
                    Log.d("for date \(date) found best time chunk: \(bestTimeChunk)")
                    let autoscheduledEvent = event.instantiateAutoscheduledEvent(forTimeChunk: bestTimeChunk)
                    autoscheduledEvents.append(autoscheduledEvent)
                    self.databaseService.saveAutoscheduledEvent(
                        autoscheduledEvent: autoscheduledEvent,
                        autoschedulingEvent: event
                    )
                } else {
                    Log.d("tried to autoschedule for event \(event.name) on date \(date) but there were no available slots.")
                }
            }
            
            // Run the completion on main thread
            DispatchQueue.main.async {
                completion(autoscheduledEvents)
            }
        }
    }
    
    /// Returns the Commitments  for StudiumEvents for a given day.
    /// - Parameter date: The date that we are retrieving commitments for
    /// - Returns: an array of Commitment objects
    private func getCommitments(for date: Date) -> [StudiumEvent: TimeChunk] {
        var commitments = [StudiumEvent: TimeChunk]()
        
        // Get all StudiumEvents
        let studiumEvents = self.databaseService.getAllStudiumObjects()
        for event in studiumEvents {
            // If the event doesn't occur on the desired date, skip it
            if !event.occursOn(date: date) {
                continue
            }
            
            let commitment = event.timeChunkForDate(date: date)
            commitments[event] = commitment
        }
        
        return commitments
    }
    
    ///Returns TimeChunks that represent the available time slots for a given day
    ///
    /// - Parameters:
    ///     - startBound: the start bound for the open time slots for the day. Ex: If this is 7:00AM, we won't schedule anything before then
    ///     - endBound: the end bound for the open time slots for the day
    ///     - commitments: the commitments that we need to avoid when looking for open slots
    /// - Returns: an Array of TimeChunk objects that represent all open time slots
    private func getOpenTimeSlots(startBound: Date, endBound: Date, commitments: [TimeChunk]) -> [TimeChunk] {
        
        // The start bound can't occur after the end bound
        if(startBound > endBound) {
            Log.e("start bound cannot occur after end bound")
            return []
        }
        
        // the available time slots
        var openSlots: [TimeChunk] = [TimeChunk(startDate: startBound, endDate: endBound)]
        
        // Iterate through each commitment to remove it from open slots.
        for commitment in commitments {
            let commitmentStartTime = commitment.startDate
            let commitmentEndTime = commitment.endDate
            
            var i = 0
            var totalIterations = 0
            let iterationLimit = 1000
            while(i < openSlots.count) {
                if (totalIterations >= iterationLimit) {
                    Log.e("getOpenTimeSlots exceeded the iterationLimit")
                    break
                }
                
                let slot = openSlots[i]
                let slotStartTime = slot.startDate
                let slotEndTime = slot.endDate
                
                // the commitment is completely within the slot, so we remove the chunk containing the commitment.
                if commitmentStartTime > slotStartTime && commitmentEndTime < slotEndTime {
                    
                    Log.d("The commitment is completely within the slot")
                    let newSlot1 = TimeChunk(startDate: slotStartTime, endDate: commitmentStartTime-1)
                    let newSlot2 = TimeChunk(startDate: commitmentEndTime+1, endDate: slotEndTime)
                    
                    
                    // remove the entire old open slot
                    openSlots.remove(at: i)
                    i-=1
                    
                    // append new open slots not including the commitment
                    openSlots.append(newSlot1)
                    openSlots.append(newSlot2)
                    
                    // the bottom portion of the commitment is within the slot.
                } else if commitmentStartTime < slotStartTime && commitmentEndTime > slotStartTime && commitmentEndTime < slotEndTime {
                    let newSlot = TimeChunk(startDate: commitmentEndTime+1, endDate: slotEndTime)
                    
                    // remove the entire old slot
                    openSlots.remove(at: i)
                    i-=1
                    
                    // add the new slot not containing the commitment
                    openSlots.append(newSlot)
                    
                    // the top portion of the commitment is within the slot.
                } else if commitmentStartTime < slotEndTime && commitmentStartTime > slotStartTime && commitmentEndTime > slotEndTime {
                    
                    // remove the entire old slot
                    openSlots.remove(at: i)
                    i-=1
                    
                    let newSlot = TimeChunk(startDate: slotStartTime, endDate: commitmentStartTime-1)
                    openSlots.append(newSlot)
                    
                    // the slot is completely within the commitment
                } else if slotStartTime >= commitmentStartTime && slotEndTime <= commitmentEndTime {
                    openSlots.remove(at: i)
                    i-=1
                }
                
                i+=1
                totalIterations += 1
            }
        }
        
        return openSlots
    }
    
    ///Finds the best time  event given the event's length in minutes and the open time slots. It does this by finding the longest open time slot and planning the event in the middle of it .
    ///
    /// - Parameters:
    ///     - openTimeSlots: the time slots available in the day. This is usually calculated by the getOpenTimeSlots function
    ///     - totalMinutes: the total length in minutes of the event we are scheduling
    /// - Returns: an array containing the start time and the end time of the event.
    private func bestTime(openTimeSlots: [TimeChunk], totalMinutes: Int) -> TimeChunk? {
        var bestTimeSlot: TimeChunk? = nil
        for openTimeSlot in openTimeSlots {
            
            // Our event can fit in the slot
            if openTimeSlot.lengthInMinutes >= totalMinutes {
                if let bestTimeSlotSafe = bestTimeSlot {
                    // This is the biggest working slot we have seen so far
                    if openTimeSlot.lengthInMinutes > bestTimeSlotSafe.lengthInMinutes {
                        bestTimeSlot = openTimeSlot
                    }
                } else {
                    bestTimeSlot = openTimeSlot
                }
            }
        }
        
        // If there is a best time slot, take its midpoint and return a TimeChunk in the middle that is the events length
        if let bestTimeSlot = bestTimeSlot {
            let midpoint = bestTimeSlot.midpoint
            return TimeChunk(startDate: midpoint.subtract(minutes: totalMinutes / 2), endDate: midpoint.add(minutes: totalMinutes / 2))
        }
        
        return nil
    }
    
    /// Finds all of the dates for certain weekdays between two dates
    /// - Parameters:
    ///   - startDate: The start bound for the range
    ///   - endDate: The end bound for the range
    ///   - weekdays: The days that we're looking for
    /// - Returns: An array of Date objects which represent applicable days
    private func findAllApplicableDatesBetween(
        startDate: Date,
        endDate: Date,
        weekdays: Set<Weekday>
    ) -> [Date] {
        Log.d("findAllApplicableDatesBetween")
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
