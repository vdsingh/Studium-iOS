//
//  NotificationsController.swift
//  Studium
//
//  Created by Vikram Singh on 8/8/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//
import UIKit
import UserNotifications
import Foundation

class NotificationsController: UIViewController{
    

    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewDidLoad() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "toWakeUpTimes", sender: self)

            }
        }
        DispatchQueue.main.async {
          self.navigationController?.isNavigationBarHidden = false
        }
        
//        let content = UNMutableNotificationContent()
//        content.title = "Hey I'm a Notification!"
//        content.body = "Hey I'm the body!"
//
//        let date = Date().addingTimeInterval(10)
//        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//
//        let idString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: idString, content: content, trigger: trigger)
//
//        center.add(request) { (error) in
//
//        }
    }
    
    
}
