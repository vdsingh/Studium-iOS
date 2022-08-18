//
//  NotificationHandler.swift
//  Studium
//
//  Created by Vikram Singh on 8/17/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationHandler {
    static func scheduleNotificationsForCourse(course: Course) {
        let alertTimes = course.notificationAlertTimes
        let daysSelected = course.days
        let startDate = course.startDate
        let name = course.name
        for alertTime in alertTimes {
            for day in daysSelected {
//                        let weekday = Date.convertDayToWeekday(day: day)
//                        let weekdayAsInt = Date.convertDayToInt(day: day)
                var alertDate = Date()
                if startDate.weekday != day{ //the course doesn't occur today
                    alertDate = Date.today().next(Date.convertDayToWeekday(day: day))
                }
                
                alertDate = Calendar.current.date(bySettingHour: startDate.hour, minute: startDate.minute, second: 0, of: alertDate)!
                
                alertDate -= (60 * Double(alertTime))
                //                    alertDate = startDate - (60 * Double(alertTime))
                //consider how subtracting time from alertDate will affect the weekday component.
                let courseComponents = DateComponents(hour: alertDate.hour, minute: alertDate.minute, second: 0, weekday: alertDate.weekday)
                //                    print(courseComponents)
                
                //adjust title as appropriate
                var title = ""
                if alertTime < 60 {
                    title = "\(name) starts in \(alertTime) minutes."
                } else if alertTime == 60 {
                    title = "\(name) starts in 1 hour"
                } else {
                    title = "\(name) starts in \(alertTime / 60) hours"
                }
                //                    let alertTimeDouble: Double = Double(alertTime)
                let timeFormat = startDate.format(with: "h:mm a")
                
                
                let identifier = UUID().uuidString
                //keeping track of the identifiers of notifs associated with the course.
                course.notificationIdentifiers.append(identifier)

                scheduleNotification(components: courseComponents, body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
            }
        }
    }
    
    //method to schedule Local Notifications to the User.
    static func scheduleNotification(components: DateComponents, body: String, titles:String, repeatNotif: Bool, identifier: String) {
        
        
//        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeatNotif)
        
        
        let content = UNMutableNotificationContent()
        content.title = titles
        content.body = body
        content.sound = UNNotificationSound.default
//        content.categoryIdentifier = identifier
        
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        //identifiers for courses are stored as "courseName alertTime"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        print(request)
//        UNUserNotificationCenter.curren///t().delegate = self
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if error != nil {
                print("$ ERROR: error with adding notification")
            }else{
                print("$ LOG: notification scheduled.")
                
            }
        }
    }
}
