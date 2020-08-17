//
//  MasterForm.swift
//  Studium
//
//  Created by Vikram Singh on 7/1/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import RealmSwift

//characteristics of all forms.
class MasterForm: UITableViewController, UNUserNotificationCenterDelegate{
    //reference to the realm database.
    let realm = try! Realm()
    
    
    //method to schedule Local Notifications to the User.
    func scheduleNotification(components: DateComponents, body: String, titles:String, repeatNotif: Bool, identifier: String) {
        
//        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
        print(components)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeatNotif)
        
        
        let content = UNMutableNotificationContent()
        content.title = titles
        content.body = body
        content.sound = UNNotificationSound.default
//        content.categoryIdentifier = identifier
        
        
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        //identifiers for courses are stored as "courseName alertTime"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        print(request)
//        UNUserNotificationCenter.curren///t().delegate = self
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if error != nil {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
}


