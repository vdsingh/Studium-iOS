//
//  AutoscheduleService.swift
//  Studium
//
//  Created by Vikram Singh on 4/18/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
final class AutoscheduleService {
    
    let debug = true
    
    static let shared = AutoscheduleService()
    
    private init() {}
    
    /// Autoschedules a StudiumEvent (WARNING: changes the start and end dates of the StudiumEvent object)
    /// - Parameters:
    ///   - event: The StudiumEvent that we are scheduling
    ///   - date: The date on which to schedule the event
    func autoScheduleEvent(event: StudiumEvent, date: Date) {
        printDebug("Autoscheduling for event \(event.name), which is \(event.totalLengthMinutes) minutes long")
        let startBound = DatabaseService.shared.getUserSettings().getWakeUpTime(for: date) ?? date.startOfDay
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
    func getCommitments(for date: Date) -> [TimeChunk] {
        var commitments = [TimeChunk]()
        
        // Get all StudiumEvents
        let studiumEvents = DatabaseService.shared.getStudiumObjects(expecting: StudiumEvent.self)
        
        for event in studiumEvents {
            // Create a commitment for the StudiumEvent
            var commitment = TimeChunk(startDate: event.startDate, endDate: event.endDate)
            
            // If the StudiumEvent is recurring, check if it occurs on the specified date. If so, create a new commitment.
            if let event = event as? RecurringStudiumEvent,
               event.occursOn(date: date),
               let startDate = date.setTime(hour: event.startDate.hour, minute: event.startDate.minute, second: event.startDate.second),
               let endDate = date.setTime(hour: event.endDate.hour, minute: event.endDate.minute, second: event.endDate.second) {
                commitment = TimeChunk(startDate: startDate, endDate: endDate)
            }
            
            
            commitments.append(commitment)
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
        
        //the available time slots
        var openSlots: [TimeChunk] = [TimeChunk(startDate: startBound, endDate: endBound)]
        
        //Iterate through each commitment to remove it from open slots.
        for commitment in commitments {
            let commitmentStartTime = commitment.startDate
            let commitmentEndTime = commitment.endDate
            
            var i = 0
            while(i < openSlots.count){
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
        let commitments = self.getCommitments(for: dateToScheduleOn)
        let openTimeSlots = self.getOpenTimeSlots(startBound: startBound, endBound: endBound, commitments: commitments)
        if !openTimeSlots.isEmpty {
            return self.bestTime(openTimeSlots: openTimeSlots, totalMinutes: totalMinutes)
        }else{
            return nil
        }
    }
    
    //TODO: docstring
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
    
    
    func autoscheduleStudyTime(parentAssignment: Assignment){
        if parentAssignment.autoschedule {
            printDebug("autoscheduling study time for assignment: \(parentAssignment.name)")
            let datesToAutoschedule = self.findAllApplicableDatesBetween(startDate: Date(), endDate: parentAssignment.endDate, weekdays: parentAssignment.days)
            printDebug("the applicable dates to autoschedule study time are: \(datesToAutoschedule)")
            for date in datesToAutoschedule {
                let studyTimeAssignment = Assignment(parentAssignment: parentAssignment)
                self.autoScheduleEvent(event: studyTimeAssignment, date: date)

                if let course = studyTimeAssignment.parentCourse {
                    DatabaseService.shared.saveStudiumObject(studyTimeAssignment)
                } else {
                    print("$ERR (AutoscheduleService): tried to autoschedule study time for assignment \(parentAssignment.name) but the parent course was nil. The parent assignment course is: \(String(describing: parentAssignment.parentCourse?.name))")
                }
            }
        }
    }
}

extension AutoscheduleService: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (AutoscheduleService): \(message)")
        }
    }
}

class TimeChunk {
    let startDate: Date
    let endDate: Date
    
    var lengthInMinutes: Int {
        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: startDate, to: endDate)
        return diffComponents.minute ?? 0
    }
    
    var midpoint: Date {
        return startDate.addingTimeInterval(endDate.timeIntervalSince(startDate) / 2)
    }
    
    init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}
