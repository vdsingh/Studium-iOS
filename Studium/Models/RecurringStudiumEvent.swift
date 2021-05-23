//
//  RecurringStudiumEvent.swift
//  Studium
//
//  Created by Vikram Singh on 5/19/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import Foundation
import EventKit
import CalendarKit
import RealmSwift

protocol Autoscheduleable: StudiumEvent{
    var autoLengthMinutes: Int {get set}
    
//    var autoDays: List<String> {get set}
    
    var autoschedule: Bool {get set}
//    dynamic var scheduledEvents: List<StudiumEvent> {get set}
    
    
}

class RecurringStudiumEvent: StudiumEvent{
    var days: List<Int> = List<Int>()
    
    ///Adds the event to Apple calendar
    ///Todo: make sure if the event is being edited, it overwrites the previous events in Apple Calendar.
    override func addToAppleCalendar(){
        let store = EKEventStore()
        let event = EKEvent(eventStore: store)
        
        let identifier = UserDefaults.standard.string(forKey: "appleCalendarID")
        if identifier == nil{ //the user is not synced with Apple Calendar
            return
        }
        
        event.location = location
        event.calendar = store.calendar(withIdentifier: identifier!) ?? store.defaultCalendarForNewEvents
        event.title = name
        event.startDate = startDate
        event.endDate = endDate
        event.notes = additionalDetails
        
        let daysDict: [Int: EKRecurrenceDayOfWeek] = [
            2: EKRecurrenceDayOfWeek(EKWeekday.monday),
            3: EKRecurrenceDayOfWeek(EKWeekday.tuesday),
            4: EKRecurrenceDayOfWeek(EKWeekday.wednesday),
            5: EKRecurrenceDayOfWeek(EKWeekday.thursday),
            6: EKRecurrenceDayOfWeek(EKWeekday.friday),
            7: EKRecurrenceDayOfWeek(EKWeekday.saturday),
            1: EKRecurrenceDayOfWeek(EKWeekday.sunday)]
        var newDays: [EKRecurrenceDayOfWeek] = []
        for day in days{
            newDays.append(daysDict[day]!)
        }
//        event.addRecurrenceRule(EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, end: nil))
        event.addRecurrenceRule(EKRecurrenceRule(recurrenceWith: .weekly, interval: 1, daysOfTheWeek: newDays, daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: nil))

        do{
            try store.save(event, span: EKSpan.futureEvents, commit: true)
        }catch let error as NSError{
            print("Failed to save event. Error: \(error)")
        }
    }
    
    
}

