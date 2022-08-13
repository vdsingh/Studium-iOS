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

public enum FormCellType {
    case textFieldCell
    case switchCell
    case labelCell
    case timeCell
    case timePickerCell
    case daySelectorCell
    case segmentedControlCell
    case colorPickerCell
    case pickerCell
    case logoCollectionViewCell
    case themeCell
    case logoCell
}
//characteristics of all forms.
class MasterForm: UITableViewController, UNUserNotificationCenterDelegate, AlertInfoStorer{
    var alertTimes: [Int] = []
    
    //reference to the realm database.
    let app = App(id: Secret.appID)
    
    var realm: Realm!
    
    override func viewDidLoad() {
        guard let user = app.currentUser else {
            print("Error getting user in MasterForm")
            return
        }
        realm = try! Realm(configuration: user.configuration(partitionValue: user.id))
        
        /// registering the necessary cells for the form.
        tableView.register(UINib(nibName: TextFieldCell.id, bundle: nil), forCellReuseIdentifier: TextFieldCell.id)
        tableView.register(UINib(nibName: TimeCell.id, bundle: nil), forCellReuseIdentifier: TimeCell.id)
        tableView.register(UINib(nibName: PickerCell.id, bundle: nil), forCellReuseIdentifier: PickerCell.id)
        tableView.register(UINib(nibName: TimePickerCell.id, bundle: nil), forCellReuseIdentifier: TimePickerCell.id)
        tableView.register(UINib(nibName: LabelCell.id, bundle: nil), forCellReuseIdentifier: LabelCell.id)
        tableView.register(UINib(nibName: SwitchCell.id, bundle: nil), forCellReuseIdentifier: SwitchCell.id)
        tableView.register(UINib(nibName: DaySelectorCell.id, bundle: nil), forCellReuseIdentifier: DaySelectorCell.id)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.systemBackground

      return headerView
    }
    
    
    //method to schedule Local Notifications to the User.
    func scheduleNotification(components: DateComponents, body: String, titles:String, repeatNotif: Bool, identifier: String) {
        
        
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
                print("ERROR: error with adding notification")
            }else{
                print("LOG: notification scheduled.")
                
            }
        }
    }
    
    func processAlertTimes() {
        
    }
    
}


