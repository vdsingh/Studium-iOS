////
////  NotificationHandler.swift
////  Studium
////
////  Created by Vikram Singh on 8/17/22.
////  Copyright © 2022 Vikram Singh. All rights reserved.
////
//
//import Foundation
//import UserNotifications
//
//
////TODO: Review and make singleton
//class NotificationHandler {
//    static func scheduleNotificationsForCourse(course: Course) {
//        let alertTimes = course.alertTimes
//        let daysSelected = course.days
//        let startDate = course.startDate
//        let name = course.name
//        for alertTime in alertTimes {
//            for day in daysSelected {
////                        let weekday = Date.convertDayToWeekday(day: day)
////                        let weekdayAsInt = Date.convertDayToInt(day: day)
//                var alertDate = Date()
//                if startDate.weekday != day{ //the course doesn't occur today
//                    alertDate = Date.today().next(Date.convertDayToWeekday(day: day))
//                }
//                
//                alertDate = Calendar.current.date(bySettingHour: startDate.hour, minute: startDate.minute, second: 0, of: alertDate)!
//                
//                alertDate -= (60 * Double(alertTime))
//                //                    alertDate = startDate - (60 * Double(alertTime))
//                //consider how subtracting time from alertDate will affect the weekday component.
//                let courseComponents = DateComponents(hour: alertDate.hour, minute: alertDate.minute, second: 0, weekday: alertDate.weekday)
//                //                    print(courseComponents)
//                
//                //adjust title as appropriate
//                var title = ""
//                if alertTime < 60 {
//                    title = "\(name) starts in \(alertTime) minutes."
//                } else if alertTime == 60 {
//                    title = "\(name) starts in 1 hour"
//                } else {
//                    title = "\(name) starts in \(alertTime / 60) hours"
//                }
//                //                    let alertTimeDouble: Double = Double(alertTime)
//                let timeFormat = startDate.format(with: "h:mm a")
//                
//                
//                let identifier = UUID().uuidString
//                //keeping track of the identifiers of notifs associated with the course.
//                course.notificationIdentifiers.append(identifier)
//
//                scheduleNotification(components: courseComponents, body: "Be there by \(timeFormat). Don't be late!", titles: title, repeatNotif: true, identifier: identifier)
//            }
//        }
//    }
//    
//    static func scheduleNotificationsForAssignment(assignment: Assignment) {
//        let alertTimes = assignment.alertTimes
//        let dueDate = assignment.endDate
//        let name = assignment.name
//        for alertTime in alertTimes {
//            let alertDate = dueDate - (Double(alertTime.rawValue) * 60)
//            var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
//            components.second = 0
//
//            let identifier = UUID().uuidString
//            
////            assignment.notificationIdentifiers.append(identifier)
//            NotificationHandler.scheduleNotification (
//                components: components,
//                body: "",
//                titles: "\(name) due at \(dueDate.format(with: "h:mm a"))",
//                repeatNotif: false,
//                identifier: identifier
//            )
//        }
//    }
//    
////    static func updateNotificationsForAssignment(assignment: Assignment) {
////        do{
////            let alertTimes = assignment.notificationAlertTimes
////            let dueDate = assignment.endDate
//////            try realm.write{
//////                assignment!.updateNotifications(with: alertTimes)
//////            }
////            for alertTime in alertTimes{
////                if !assignment.notificationAlertTimes.contains(alertTime){
////                    let alertDate = dueDate - (Double(alertTime) * 60)
////                    var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alertDate)
////                    components.second = 0
////                    let identifier = UUID().uuidString
////                    try realm.write{
////                        print("scheduling new notification for alertTime: \(alertTime)")
////                        assignment!.notificationIdentifiers.append(identifier)
////                        assignment!.notificationAlertTimes.append(alertTime)
////                    }
////                    NotificationHandler.scheduleNotification(components: components, body: "", titles: "\(name) due at \(dueDate.format(with: "h:mm a"))", repeatNotif: false, identifier: identifier)
////                }
////            }
////            try realm.write{
////                print("Edited Assignment with \(workTimeHours) and \(workTimeMinutes)")
////                guard let user = app.currentUser else {
////                    print("$ ERROR: error getting user")
////                    return
////                }
////                assignment!.initializeData(name: name, additionalDetails: additionalDetails, complete: false, startDate: dueDate - (60*60), endDate: dueDate, notificationAlertTimes: alertTimes, autoschedule: scheduleWorkTime, autoLengthMinutes: workTimeMinutes, autoDays: workDaysSelected, partitionKey: user.id)
////
////            }
////        }catch{
////            print("$ ERROR: \(error)")
////        }
////    }
//    
//    //method to schedule Local Notifications to the User.
//    static func scheduleNotification(components: DateComponents, body: String, titles:String, repeatNotif: Bool, identifier: String) {
//        
//        
////        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeatNotif)
//        
//        
//        let content = UNMutableNotificationContent()
//        content.title = titles
//        content.body = body
//        content.sound = UNNotificationSound.default
////        content.categoryIdentifier = identifier
//        
//        
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        //identifiers for courses are stored as "courseName alertTime"
////        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
////        print(request)
////        UNUserNotificationCenter.curren///t().delegate = self
//        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        UNUserNotificationCenter.current().add(request) {(error) in
//            if error != nil {
//                print("$ ERROR: error with adding notification")
//            }else{
//                print("$ LOG: notification scheduled.")
//                
//            }
//        }
//    }
//}
