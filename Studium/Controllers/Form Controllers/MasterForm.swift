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
class MasterForm: UITableViewController, UNUserNotificationCenterDelegate, AlertInfoStorer {
    //TODO: Figure out this Protocol Function
    func processAlertTimes() {
        
    }
    
    var alertTimes: [Int] = []
    
    //TODO: Abstract Realm and App to separate layer
    //reference to the realm database.
//    let app = App(id: Secret.appID)
    
//    var realm: Realm!
    
    override func viewDidLoad() {
//        guard let user = app.currentUser else {
//            print("Error getting user in MasterForm")
//            return
//        }
//        realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.systemBackground

      return headerView
    }
    
    //TODO: Abstract notifications to a notification handler.
    
    //method to schedule Local Notifications to the User.
    func scheduleNotification(components: DateComponents, body: String, titles:String, repeatNotif: Bool, identifier: String) {
        
        
//        let triggerWeekly = Calendar.current.dateComponents([.weekday,.hour,.minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: repeatNotif)
        
        
        let content = UNMutableNotificationContent()
        content.title = titles
        content.body = body
        content.sound = UNNotificationSound.default
        
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        //identifiers for courses are stored as "courseName alertTime"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        print(request)
//        UNUserNotificationCenter.curren///t().delegate = self
        //UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if error != nil {
                print("$Error: error with adding notification")
            }else{
                print("$Log: notification scheduled.")
                
            }
        }
    }
}


