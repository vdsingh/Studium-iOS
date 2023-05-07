//
//  SettingsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 7/21/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit
import EventKit
import GoogleSignIn

class SettingsViewController: UITableViewController, AlertTimeHandler {
    func alertTimesWereUpdated(selectedAlertOptions: [AlertOption]) {
        self.databaseService.setDefaultAlertOptions(alertOptions: selectedAlertOptions)
    }
    
    
    var databaseService: DatabaseServiceProtocol! = DatabaseService.shared
    
    //TODO: Docstrings
//    var alertTimes: [AlertOption] = []
    
    //TODO: Docstrings
//    var realm: Realm! //Link to the realm where we are storing information
    
    //TODO: Docstrings
    let app = App(id: Secret.appID)
    
    /// reference to defaults
    let defaults = UserDefaults.standard
    
    //TODO: Docstrings
    let cellData: [[String]] = [["Set Default Notifications", "Reset Wake Up Times"],
//                                ["Sync to Apple Calendar"],
                                ["Delete All Assignments","Delete Completed Assignments",  "Delete All Other Events", "Delete All Completed Other Events"],
                                ["Email", "Sign Out"]]
    
    //TODO: Docstrings
    let cellLinks: [[String]] = [["toAlertSelection", "toWakeUpTimes", ""],
//                                [""],
                                ["", "", "", ""],
                                ["", "toLoginScreen"]]
    
    //TODO: Docstrings
    let alertData: [[String]] = [
        ["Delete All Assignments", "Are you sure you want to delete all assignments? You can't undo this action."],
        ["Delete Completed Assignments", "Are you sure you want to delete all completed assignments? You can't undo this action."],
        ["Delete All Other Events", "Are you sure you want to delete all other events? You can't undo this action."],
        ["Delete All Completed Other Events", "Are you sure you want to delete all completed other events? You can't undo this action."]]
    
    override func viewDidLoad() {
        self.tableView.tableFooterView = UIView()

        //the key for default notification times doesn't exist in UserDefaults
//        if defaults.object(forKey: K.defaultNotificationTimesKey) == nil {
//            defaults.setValue(alertTimes, forKey: K.defaultNotificationTimesKey)
//        } else {
//            if let times = defaults.value(forKey: K.defaultNotificationTimesKey) as? [Int] {
//                self.alertTimes = times.compactMap { AlertOption(rawValue: $0) }
//            }
//        }
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryAccent.uiColor
        
        navigationController?.navigationBar.prefersLargeTitles = true

        
        self.view.backgroundColor = StudiumColor.background.uiColor
        self.navigationController?.navigationBar.barTintColor = StudiumColor.background.uiColor
    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.backgroundColor = StudiumColor.secondaryBackground.uiColor
        cell?.textLabel?.textColor = StudiumColor.primaryLabel.uiColor
        cell?.textLabel?.text = cellData[indexPath.section][indexPath.row]
        
        
//        if defaults.value(forKey: "email") != nil && cellData[indexPath.section][indexPath.row] == "Email"{
//            cell?.textLabel?.text = defaults.string(forKey: "email")
//        }
        
        let id = AuthenticationService.shared.userID
        if cellData[indexPath.section][indexPath.row] == "Email" {
            cell?.textLabel?.text = id
        }
        
        
        return cell!
    }
    
    //TODO: Docstrings
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cellData.count
    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData[section].count
    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        
        return K.emptyHeaderHeight
    }
    
    //TODO: Docstrings
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if cellLinks[indexPath.section][indexPath.row] != "" {
            performSegue(withIdentifier: cellLinks[indexPath.section][indexPath.row], sender: self)
        }
        
        if cellData[indexPath.section][indexPath.row] == "Clear Notifs"{
            let center = UNUserNotificationCenter.current()
            center.removeAllDeliveredNotifications()    // to remove all delivered notifications
            center.removeAllPendingNotificationRequests()   // to remove all pending notifications
            UIApplication.shared.applicationIconBadgeNumber = 0 // to clear the icon notification badge
        }else if cellData[indexPath.section][indexPath.row] == "Delete All Assignments"{
            createAlertForAssignments(title: alertData[0][0], message: alertData[0][1], isCompleted: false)
        }else if cellData[indexPath.section][indexPath.row] == "Delete Completed Assignments"{
            createAlertForAssignments(title: alertData[1][0], message: alertData[1][1], isCompleted: true)
        }else if cellData[indexPath.section][indexPath.row] == "Delete All Other Events"{
            createAlertForOtherEvents(title: alertData[2][0], message: alertData[2][1], isCompleted: false)
        }else if cellData[indexPath.section][indexPath.row] == "Delete All Completed Other Events"{
            createAlertForOtherEvents(title: alertData[3][0], message: alertData[3][1], isCompleted: true)
        }else if cellData[indexPath.section][indexPath.row] == "Sign Out" {
            
            //TODO: handle log out
//            K.handleLogOut()
            
//            self.navigationController?.popToRootViewController(animated: true)
//            guard let vc = self.presentingViewController else { return }
//
//            print("Dismissing VC")
//            vc.dismiss(animated: true, completion: nil)
//            vc.dismiss(animated: true, completion: nil)
//            vc.dismiss(animated: true, completion: nil)

//            performSegue(withIdentifier: "toLoginScreen", sender: self)
            AuthenticationService.shared.handleLogOut { error in
                if let error = error {
                    print("$ERR (SettingsViewController): \(String(describing: error))")
                }
            }
        } else if cellData[indexPath.section][indexPath.row] == "Sync to Apple Calendar" {
            // Initialize the store.
            let store = EKEventStore()

            // Request access to reminders.
            store.requestAccess(to: .event) { granted, error in
                if granted{
                    let calendars = store.calendars(for: EKEntityType.event) as [EKCalendar]
                    for calendar in calendars{
                        if calendar.title == "Studium"{ // the calendar already exists.
                            return
                        }
                    }

                    let studiumCalendar = EKCalendar(for: EKEntityType.event, eventStore: store)
                    studiumCalendar.title = "Studium"
                    studiumCalendar.source = store.defaultCalendarForNewEvents?.source
                    self.defaults.setValue(studiumCalendar.calendarIdentifier, forKey: "appleCalendarID")
                    print("Calendar Identifier: \(studiumCalendar.calendarIdentifier)")
                    try! store.saveCalendar(studiumCalendar, commit: true)

//                    do{
//                    }catch error as NSError{
//                        print("Error creating Apple calendar: \(error)")
//                    }
                }else{
                    print("error syncing to apple calendar: \(String(describing: error))")
                }
            }
        } else if cellData[indexPath.section][indexPath.row] == "Set Default Notifications" {
            
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.backgroundColor = UIColor.secondarySystemBackground
    }
    
    //edit the background color of section headers
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: K.emptyHeaderHeight))
        headerView.backgroundColor = StudiumColor.background.uiColor
        return headerView
    }
//    221406332443-he18tqfi4jbg40mbgpgmaaebenekh208.apps.googleusercontent.com
    
    //TODO: Docstrings
    func deleteAllAssignments(isCompleted: Bool) {
        let assignments = self.databaseService.getStudiumObjects(expecting: Assignment.self)
        for assignment in assignments {
            if (isCompleted && assignment.complete) || !isCompleted {
                self.databaseService.deleteStudiumObject(assignment)
            }
        }
    }
    
    //TODO: Docstrings
    func deleteAllOtherEvents(isCompleted: Bool) {
        let otherEvents = self.databaseService.getStudiumObjects(expecting: OtherEvent.self)
        for event in otherEvents {
            if (isCompleted && event.complete) || !isCompleted {
                self.databaseService.deleteStudiumObject(event)
            }
        }
    }
    
    //TODO: Docstrings
    func createAlertForAssignments(title: String, message: String, isCompleted: Bool){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteAllAssignments(isCompleted: isCompleted)
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    //TODO: Docstrings
    func createAlertForOtherEvents(title: String, message: String, isCompleted: Bool){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteAllOtherEvents(isCompleted: isCompleted)
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    //TODO: Docstrings
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? AlertTableViewController {
            destinationVC.delegate = self
            destinationVC.setSelectedAlertOptions(alertOptions: self.databaseService.getDefaultAlertOptions())
        }
    }
}
