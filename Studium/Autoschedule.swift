//
//  Autoschedule.swift
//  Studium
//
//  Created by Vikram Singh on 5/22/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
class Autoschedule{
    
    ///Returns a 2D Date Array with the commitments for a given day. Ex: [[12:00PM, 2:00PM],[4:00PM, 7:00PM]]. There are 2 commitments on the given date. 1 is from 12:00PM to 2:00PM and the other is from 4:00PM to 7:00PM
    ///
    /// - Parameters:
    ///     - date: the date in which we want to find all commitments
    /// - Returns: a 2D date Array that describes all commitments for the given date
    static func getCommitments(date: Date)->[[Date]]{
        var commitments:[[Date]] = []
                
        //do the courses
        guard let user = K.app.currentUser else {
            print("Error getting user")
            return [[]]
        }
        let realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        
        //add the courses
        let courses = realm.objects(Course.self)
        for course in courses{
            if course.days.contains(date.day){
                let courseStartDate = Date(year: date.year, month: date.month, day: date.day, hour: course.startDate.hour, minute: course.startDate.minute, second: 0)
                let courseEndDate = Date(year: date.year, month: date.month, day: date.day, hour: course.endDate.hour, minute: course.endDate.minute, second: 0)
                let newCourseCommitment = [courseStartDate, courseEndDate]
                commitments.append(newCourseCommitment)
            }
        }
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let broadDate = Calendar.current.date(from: components)!
        
        let otherEvents = realm.objects(OtherEvent.self).filter("startDate == %@", broadDate)
        print("Retrieved otherEvents: \(otherEvents)")
        for otherEvent in otherEvents{
        
            let otherEventStartDate = Date(year: date.year, month: date.month, day: date.day, hour: otherEvent.startDate.hour, minute: otherEvent.startDate.minute, second: 0)
            var otherEventEndDate = Date(year: date.year, month: date.month, day: date.day, hour: otherEvent.endDate.hour, minute: otherEvent.endDate.minute, second: 0)
            if(otherEventEndDate.day > date.day){
                //if the otherEvent ends on a later day, just make the commitment window the end of the current day.
                otherEventEndDate = Date(year: date.year, month: date.month, day: date.day, hour: 23, minute: 59, second: 0)
            }
            let newOtherEventCommitment = [otherEventStartDate, otherEventEndDate]
            commitments.append(newOtherEventCommitment)
        }
                
        //add the courses
        let habits = realm.objects(Habit.self)
        for habit in habits{
            if habit.days.contains(date.day){
                let habitStartDate = Date(year: date.year, month: date.month, day: date.day, hour: habit.startDate.hour, minute: habit.startDate.minute, second: 0)
                let habitEndDate = Date(year: date.year, month: date.month, day: date.day, hour: habit.endDate.hour, minute: habit.endDate.minute, second: 0)
                let newCourseCommitment = [habitStartDate, habitEndDate]
                commitments.append(newCourseCommitment)
            }
        }
        return commitments
    }


    ///Returns a 2D Date Array with the available time slots for a given day (so that we know when we can schedule an event)
    ///
    /// - Parameters:
    ///     - startBound: the start bound for the open time slots for the day. Ex: If this is 7:00AM, we won't schedule anything before then
    ///     - endBound: the end bound for the open time slots for the day
    ///     - commitments: the commitments that we need to avoid when looking for open slots. If there is a commitment from 3:00PM-4:00PM we don't want to autoschedule anything during that time
    /// - Returns: a 2D date Array that describes all open time slots
    static func getOpenTimeSlots(startBound: Date, endBound: Date, commitments: [[Date]]) -> [[Date]]{
    //the available time slots. Ex: [[9:00-12:00], [16:00-20:00]]
        var openSlots: [[Date]] = [[startBound, endBound]]
        for commitment in commitments{
            let commitmentStartTime = commitment[0]
            let commitmentEndTime = commitment[1]
            print("Commitment: start \(commitmentStartTime) end \(commitmentEndTime)")
            for i in 0...openSlots.count-1{
                let slot = openSlots[i]
                let slotStartTime = slot[0]
                let slotEndTime = slot[1]
                
                if(commitmentStartTime > slotStartTime && commitmentEndTime < slotEndTime){
                    //the commitment is completely within the slot
                    
                    print("The commitment is completely within the slot")
                    let newSlot1 = [slotStartTime, commitmentStartTime-1]
                    let newSlot2 = [commitmentEndTime+1, slotEndTime]
                    
                    //avoid removing anything because we want to avoid shifting (inefficient)
                    openSlots.append(newSlot1)
                    openSlots.append(newSlot2)

                }else if(commitmentStartTime < slotStartTime && commitmentEndTime > slotStartTime && commitmentEndTime < slotEndTime){
                    //the bottom portion of the commitment is within the slot.
                    let newSlot = [commitmentEndTime+60, slotEndTime]
                    
                    openSlots.append(newSlot)
                }else if(commitmentStartTime < slotEndTime && commitmentStartTime > slotStartTime && commitmentEndTime > slotEndTime){
                    //the top portion of the commitment is within the slot.
                    
                    let newSlot = [slotStartTime, commitmentStartTime - 60]
                    openSlots.append(newSlot)
                }else if(slotStartTime >= commitmentStartTime && slotEndTime <= commitmentEndTime){
                    //the slot is completely within the commitment
    //                openSlots.remove(at: i)
                }
            }
        }
        return openSlots
    }
    
    ///Finds the best time range for an event given the event's length in minutes and the open time slots. It does this by finding the longest open time slot and planning the event in the middle of it .
    ///
    /// - Parameters:
    ///     - openTimeSlots: the time slots available in the day. This is usually calculated by the getOpenTimeSlots function
    ///     - totalMinutes: the total length in minutes of the event we are scheduling
    /// - Returns: an array containing the start time and the end time of the event.
    static func bestTime(openTimeSlots: [[Date]], totalMinutes: Int)->[Date]{
        var maxSlotLength: Int = 0
        var bestTimeSlot: [Date] = [Date(), Date()]
        for i in 0...openTimeSlots.count-1{
            if Int(openTimeSlots[i][1].timeIntervalSince(openTimeSlots[i][0]))/60 > totalMinutes{
                let slot = openTimeSlots[i]
                
                let slotLength = slot[1].minutes(from: slot[0])
                if(slotLength > maxSlotLength){
                    maxSlotLength = slotLength
                    
                    let calendar = Calendar.current
                    let midPoint = calendar.date(byAdding: .minute, value: slotLength/2, to: slot[0])!
                    
                    print("midPoint: \(midPoint)")
                    print("totalMinutes: \(totalMinutes)")
                                            
                    let assignmentStart = Calendar.current.date(byAdding: .minute, value: -(totalMinutes/2), to: midPoint)!
                    let assignmentEnd = Calendar.current.date(byAdding: .minute, value: totalMinutes/2, to: midPoint)!

                    bestTimeSlot[0] = assignmentStart
                    bestTimeSlot[1] = assignmentEnd
                }
            }
        }
        
        return bestTimeSlot
    }
}
