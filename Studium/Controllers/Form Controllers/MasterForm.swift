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
    
    func scheduleNotification(at date: Date, body: String, titles:String, repeatNotif: Bool) {
        
        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerWeekly, repeats: repeatNotif)
        
        let content = UNMutableNotificationContent()
        content.title = titles
        content.body = body
        content.sound = UNNotificationSound.default
//        content.categoryIdentifier = "courses"
        
        let request = UNNotificationRequest(identifier: "textNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    }
}


