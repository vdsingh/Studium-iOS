//
//  AutoscheduleService.swift
//  Studium
//
//  Created by Vikram Singh on 4/18/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import VikUtilityKit

//TODO: Docstrings
protocol AutoscheduleServiceProtocol {
    func autoscheduleEvent(forEvent event: StudiumEvent, onDate date: Date)
    func getCommitments(for date: Date) -> [StudiumEvent: TimeChunk]
    func getOpenTimeSlots(startBound: Date, endBound: Date, commitments: [TimeChunk]) -> [TimeChunk]
    func bestTime(openTimeSlots: [TimeChunk], totalMinutes: Int) -> TimeChunk?
    func findAutoscheduleTimeChunk(dateToScheduleOn: Date, startBound: Date, endBound: Date, totalMinutes: Int) -> TimeChunk?
    func findAllApplicableDatesBetween(startDate: Date, endDate: Date, weekdays: Set<Weekday>) -> [Date]
    func autoscheduleStudyTime(parentAssignment: Assignment)
}

//TODO: Docstrings
final class AutoscheduleService: AutoscheduleServiceProtocol, Debuggable {
    
    let debug = true
    
    //TODO: Docstrings
    let databaseService: DatabaseServiceProtocol
    
    static let shared = AutoscheduleService(databaseService: DatabaseService.shared)
    
    //TODO: Docstrings
//    static let shared = AutoscheduleService(databaseService: DatabaseService.shared)
    
    //TODO: Docstrings
    init(databaseService: DatabaseServiceProtocol) {
        self.databaseService = databaseService
         
     }
    
    /// Autoschedules a StudiumEvent (WARNING: changes the start and end dates of the StudiumEvent object)
    /// - Parameters:
    ///   - event: The StudiumEvent that we are scheduling
    ///   - date: The date on which to schedule the event
    func autoscheduleEvent(forEvent event: StudiumEvent, onDate date: Date) {
        printDebug("Autoscheduling for event \(event.name), which is \(event.totalLengthMinutes) minutes long")
        let startBound = self.databaseService.getUserSettings().getWakeUpTime(for: date) ?? date.startOfDay
        let endBound = date.setTime(hour: 23, minute: 59, second: 0) ?? date.endOfDay
        printDebug("Autoschedule Time Bounds: \(startBound)-\(endBound)")
        
        var timeChunk: TimeChunk? = nil
        if let recurringEvent = event as? RecurringStudiumEvent,
           recurringEvent.occursOn(date: date) {
            timeChunk = self.findAutoscheduleTimeChunk(dateToScheduleOn: date, startBound: startBound, endBound: endBound, totalMinutes: recurringEvent.totalLengthMinutes)
        } else {
            timeChunk = self.findAutoscheduleTimeChunk(dateToScheduleOn: date, startBound: startBound, endBound: endBound, totalMinutes: event.totalLengthMinutes)
        }
        
        if let timeChunk = timeChunk {
            printDebug("setting timechunk to \(timeChunk.startDate) - \(timeChunk.endDate) for event \(event.name) with totalLengthMinutes: \(event.totalLengthMinutes)")
            event.setDates(startDate: timeChunk.startDate, endDate: timeChunk.endDate)
        } else {
            printDebug("Tried to autoschedule event \(event.name) but timeChunk was nil.")
        }
    }
        
    /// Returns the Commitments  for StudiumEvents for a given day.
    /// - Parameter date: The date that we are retrieving commitments for
    /// - Returns: an array of Commitment objects
    func getCommitments(for date: Date) -> [StudiumEvent: TimeChunk] {
        var commitments = [StudiumEvent: TimeChunk]()
        
        // Get all StudiumEvents
        let studiumEvents = self.databaseService.getStudiumObjects(expecting: StudiumEvent.self)
        
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
    func getOpenTimeSlots(startBound: Date, endBound: Date, commitments: [TimeChunk]) -> [TimeChunk] {
        
        // The start bound can't occur after the end bound
        if(startBound > endBound) {
            print("$ERR (AutoscheduleService): start bound cannot occur after end bound")
            return []
        }
        
        //the available time slots
        var openSlots: [TimeChunk] = [TimeChunk(startDate: startBound, endDate: endBound)]
        
        //Iterate through each commitment to remove it from open slots.
        for commitment in commitments {
            let commitmentStartTime = commitment.startDate
            let commitmentEndTime = commitment.endDate
            
            var i = 0
            while(i < openSlots.count) {
                let slot = openSlots[i]
                let slotStartTime = slot.startDate
                let slotEndTime = slot.endDate
                
                //the commitment is completely within the slot, so we remove the chunk containing the commitment.
                if(commitmentStartTime > slotStartTime && commitmentEndTime < slotEndTime){
                    
                    printDebug("The commitment is completely within the slot")
                    let newSlot1 = TimeChunk(startDate: slotStartTime, endDate: commitmentStartTime-1)
                    let newSlot2 = TimeChunk(startDate: commitmentEndTime+1, endDate: slotEndTime)

                    
                    //remove the entire old open slot
                    openSlots.remove(at: i)
                    i-=1
                    
                    //append new open slots not including the commitment
                    openSlots.append(newSlot1)
                    openSlots.append(newSlot2)

                //the bottom portion of the commitment is within the slot.
                } else if(commitmentStartTime < slotStartTime && commitmentEndTime > slotStartTime && commitmentEndTime < slotEndTime) {
                    let newSlot = TimeChunk(startDate: commitmentEndTime+1, endDate: slotEndTime)
                    
                    //remove the entire old slot
                    openSlots.remove(at: i)
                    i-=1
                    
                    //add the new slot not containing the commitment
                    openSlots.append(newSlot)
                    
                //the top portion of the commitment is within the slot.
                } else if(commitmentStartTime < slotEndTime && commitmentStartTime > slotStartTime && commitmentEndTime > slotEndTime) {
                    
                    //remove the entire old slot
                    openSlots.remove(at: i)
                    i-=1
                    
                    let newSlot = TimeChunk(startDate: slotStartTime, endDate: commitmentStartTime-1)
                    openSlots.append(newSlot)
                    
                //the slot is completely within the commitment
                } else if(slotStartTime >= commitmentStartTime && slotEndTime <= commitmentEndTime) {
                    openSlots.remove(at: i)
                    i-=1
                }
                i+=1
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
    func bestTime(openTimeSlots: [TimeChunk], totalMinutes: Int) -> TimeChunk? {
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
    
    /// Finds the correct TimeChunk for the start and end date of an autoscheduled event
    /// - Parameters:
    ///   - dateOccurring: The Date that we are autoscheduling for
    ///   - startBound: The earliest we can schedule
    ///   - endBound: The latest we can schedule
    ///   - totalMinutes: The total length of the event in minutes
    /// - Returns: A TimeChunk representing the start and end date of the autoscheduled event
    func findAutoscheduleTimeChunk(dateToScheduleOn: Date, startBound: Date, endBound: Date, totalMinutes: Int) -> TimeChunk? {
        printDebug("attempting to find autoschedule time chunk.")
        let commitments = [TimeChunk](self.getCommitments(for: dateToScheduleOn).values)
        let openTimeSlots = self.getOpenTimeSlots(startBound: startBound, endBound: endBound, commitments: commitments)
        if !openTimeSlots.isEmpty {
            return self.bestTime(openTimeSlots: openTimeSlots, totalMinutes: totalMinutes)
        }else{
            return nil
        }
    }
    
    /// Finds all of the dates for certain weekdays between two dates
    /// - Parameters:
    ///   - startDate: The start bound for the range
    ///   - endDate: The end bound for the range
    ///   - weekdays: The days that we're looking for
    /// - Returns: An array of Date objects which represent applicable days
    func findAllApplicableDatesBetween(startDate: Date, endDate: Date, weekdays: Set<Weekday>) -> [Date] {
        var resultDates = [Date]()
        let calendar = Calendar.current
        
        // Iterate through each day in the range
        var currentDate = startDate
        while currentDate <= endDate {
            let weekday = calendar.component(.weekday, from: currentDate)
            if let studiumWeekday = Weekday(rawValue: weekday) {
                
                // If the current day is a Monday, Wednesday, or Friday, add it to the result array
                if weekdays.contains(studiumWeekday) {
                    printDebug("findAllApplicableDatesBetween adding studiumWeekday \(studiumWeekday.buttonText) which is date \(currentDate)")
                    resultDates.append(currentDate)
                }
            }
            
            // Move to the next day
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return resultDates
    }
    
    //TODO: Docstring
    func autoscheduleStudyTime(parentAssignment: Assignment) {
        if parentAssignment.autoscheduling {
            printDebug("autoscheduling study time for assignment: \(parentAssignment.name)")
            let datesToAutoschedule = self.findAllApplicableDatesBetween(startDate: Date(), endDate: parentAssignment.endDate, weekdays: parentAssignment.days)
            printDebug("the applicable dates to autoschedule study time are: \(datesToAutoschedule)")
            for date in datesToAutoschedule {
                let studyTimeAssignment = Assignment(parentAssignment: parentAssignment)
                self.autoscheduleEvent(forEvent: studyTimeAssignment, onDate: date)

                if studyTimeAssignment.parentCourse != nil {
                    self.databaseService.saveStudiumObject(studyTimeAssignment)
                } else {
                    print("$ERR (AutoscheduleService): tried to autoschedule study time for assignment \(parentAssignment.name) but the parent course was nil. The parent assignment course is: \(String(describing: parentAssignment.parentCourse?.name))")
                }
            }
        }
    }
}

extension Debuggable where Self: AutoscheduleServiceProtocol {
    func printDebug(_ message: String) {
        if self.debug || DebugFlags.authentication {
            print("$LOG (AutoscheduleService): \(message)")
        }
    }
}

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
