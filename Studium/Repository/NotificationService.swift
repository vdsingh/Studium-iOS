//
//  NotificationService.swift
//  Studium
//
//  Created by Vikram Singh on 2/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import NotificationCenter

//TODO: Implement
class NotificationService {
    
    let debug = false
    
    static let shared = NotificationService()
    
    private init() { }
    
    // MARK: - Public Functions
    
    func scheduleNotificationsFor(event: StudiumEvent) {
        if let event = event as? RecurringStudiumEvent {
            self.scheduleNotificationsFor(recurringEvent: event)
        }
        
        scheduleOneTimeNotification(for: event)
    }
    
    func deleteAllPendingNotifications(for event: StudiumEvent) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: event.notificationIdentifiers)
    }
    
    // MARK: - Private Functions

    private func scheduleNotificationsFor(recurringEvent: RecurringStudiumEvent) {
        let alertTimes = recurringEvent.alertTimes
        let days = recurringEvent.days
        let startDate = recurringEvent.startDate
        let name = recurringEvent.name
        for alertTime in alertTimes {
            for day in days {
                var nextMatchingDay = Date()
                if day.rawValue != Date().weekday {
                    nextMatchingDay = Calendar.current.nextDate(after: startDate, matching: DateComponents(weekday: day.rawValue), matchingPolicy: .nextTime)!
                }
                
                
                
                var alertDate = Calendar.current.date(bySettingHour: startDate.hour, minute: startDate.minute, second: 0, of: nextMatchingDay)!
                let alertTimeValue = alertTime.rawValue
                                
                alertDate -= (60 * Double(alertTimeValue))
        
                let courseDateComponents = DateComponents(hour: alertDate.hour, minute: alertDate.minute, second: 0, weekday: day.rawValue)
                
                // adjust title as appropriate
                var title = ""
                if alertTimeValue < 60 {
                    title = "\(name) starts in \(alertTime) minutes."
                } else if alertTimeValue == 60 {
                    title = "\(name) starts in 1 hour"
                } else {
                    title = "\(name) starts in \(alertTimeValue / 60) hours"
                }
                
                let timeFormat = startDate.format(with: "h:mm a")
                
                
                let identifier = UUID().uuidString
                
                //keeping track of the identifiers of notifs associated with the course.
                recurringEvent.notificationIdentifiers.append(identifier)
                
                self.scheduleNotification(components: courseDateComponents, body: "Be there by \(timeFormat). Don't be late!", titles: title, repeats: true, identifier: identifier)
            }
        }
    }
    
    private func scheduleOneTimeNotification(for event: StudiumEvent) {
        let alertTimes = event.alertTimes
        let dueDate = event.endDate
        let name = event.name
        for alertTime in alertTimes {
            let alertDate = dueDate - (Double(alertTime.rawValue) * 60)
            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
            components.second = 0
            
            let identifier = UUID().uuidString
            
            event.notificationIdentifiers.append(identifier)
            self.scheduleNotification (
                components: components,
                body: "",
                titles: "\(name) due at \(dueDate.format(with: "h:mm a"))",
                repeats: false,
                identifier: identifier
            )
        }
    }
    
    //method to schedule Local Notifications to the User.
    private func scheduleNotification(
        components: DateComponents,
        body: String,
        titles: String,
        repeats: Bool,
        identifier: String
    ) {
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeats)
        
        let content = UNMutableNotificationContent()
        content.title = titles
        content.body = body
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("$ERR: error with adding notification: \(String(describing: error))")
            }
        }
    }
}

extension NotificationService: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (NotificationService): \(message)")
        }
    }
}

