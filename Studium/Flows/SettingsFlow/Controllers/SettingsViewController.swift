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

class SettingsViewController: UITableViewController, AlertTimeHandler, Storyboarded, ErrorShowing {
    
    private struct Constants {
        static let deleteAllAssignmentsAlertInfo = (title: "Delete All Assignments", message: "Are you sure you want to delete all assignments? You can't undo this action.")
        static let deleteCompletedAssignmentsAlertInfo = (title: "Delete Completed Assignments", message: "Are you sure you want to delete all completed assignments? You can't undo this action.")
        static let deleteAllOtherEventsAlertInfo = (title: "Delete All Other Events", message: "Are you sure you want to delete all other events? You can't undo this action.")
        static let deleteAllCompletedOtherEventsAlertInfo = (title: "Delete All Completed Other Events", message: "Are you sure you want to delete all completed other events? You can't undo this action.")
    }
    
    weak var coordinator: SettingsCoordinator?
    
    func alertTimesWereUpdated(selectedAlertOptions: [AlertOption]) {
        self.databaseService.setDefaultAlertOptions(alertOptions: selectedAlertOptions)
    }
    
    
    var databaseService: DatabaseServiceProtocol! = DatabaseService.shared
    
    /// reference to defaults
    let defaults = UserDefaults.standard
    
    //TODO: Docstrings
    lazy var cellData: [[(text: String, didSelect: (() -> Void)?)]] = [
        [
            ("Set Default Notifications", nil),
            ("Reset Wake Up Times", didSelect: {
                self.unwrapCoordinatorOrShowError()
                self.coordinator?.showUserSetupFlow()
            })
        ],
        //                                ["Sync to Apple Calendar"],
        [
            ("Delete All Assignments", didSelect: {
                self.createAlertForAssignments(title: Constants.deleteAllAssignmentsAlertInfo.title, message: Constants.deleteAllAssignmentsAlertInfo.message, isCompleted: false)

            }),
            ("Delete Completed Assignments", didSelect: {
                self.createAlertForAssignments(title: Constants.deleteCompletedAssignmentsAlertInfo.title, message: Constants.deleteCompletedAssignmentsAlertInfo.message, isCompleted: true)
            }),
            ("Delete All Other Events", didSelect: {
                self.createAlertForOtherEvents(title: Constants.deleteAllOtherEventsAlertInfo.title, message: Constants.deleteAllOtherEventsAlertInfo.message, isCompleted: false)
            }),
            ("Delete All Completed Other Events", didSelect: {
                self.createAlertForOtherEvents(title: Constants.deleteAllCompletedOtherEventsAlertInfo.title, message: Constants.deleteAllCompletedOtherEventsAlertInfo.message, isCompleted: true)

            })
        ],
        [
            ("Email", nil),
            ("Sign Out", didSelect: {
                AuthenticationService.shared.handleLogOut { error in
                    if let error = error {
                        print("$ERR (SettingsViewController): \(String(describing: error))")
                    }
                    
                    self.unwrapCoordinatorOrShowError()
                    self.coordinator?.showAuthenticationFlow()
                }
            })
            
        ]
    ]
    
    override func viewDidLoad() {
        self.tableView.tableFooterView = UIView()

        
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
        cell?.textLabel?.text = cellData[indexPath.section][indexPath.row].text
        
        
//        if defaults.value(forKey: "email") != nil && cellData[indexPath.section][indexPath.row] == "Email"{
//            cell?.textLabel?.text = defaults.string(forKey: "email")
//        }
        
        let id = AuthenticationService.shared.userID
        if cellData[indexPath.section][indexPath.row].text == "Email" {
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
//        if cellLinks[indexPath.section][indexPath.row] != "" {
//            performSegue(withIdentifier: cellLinks[indexPath.section][indexPath.row], sender: self)
//        }
        
        let cellData = self.cellData[indexPath.section][indexPath.row]
        
        if let selectAction = cellData.didSelect {
            selectAction()
        }
        
//        if cellData[indexPath.section][indexPath.row] == "Clear Notifs"{
//            let center = UNUserNotificationCenter.current()
//            center.removeAllDeliveredNotifications()    // to remove all delivered notifications
//            center.removeAllPendingNotificationRequests()   // to remove all pending notifications
//            UIApplication.shared.applicationIconBadgeNumber = 0 // to clear the icon notification badge
//        } else if cellData[indexPath.section][indexPath.row] == "Delete All Assignments" {
//        } else if cellData[indexPath.section][indexPath.row] == "Delete Completed Assignments" {
//        } else if cellData[indexPath.section][indexPath.row] == "Delete All Other Events" {
//        } else if cellData[indexPath.section][indexPath.row] == "Delete All Completed Other Events" {
//        } else if cellData[indexPath.section][indexPath.row] == "Sign Out" {
//
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

//        } else if cellData[indexPath.section][indexPath.row] == "Sync to Apple Calendar" {
            // Initialize the store.
//            let store = EKEventStore()
//
//            // Request access to reminders.
//            store.requestAccess(to: .event) { granted, error in
//                if granted{
//                    let calendars = store.calendars(for: EKEntityType.event) as [EKCalendar]
//                    for calendar in calendars{
//                        if calendar.title == "Studium"{ // the calendar already exists.
//                            return
//                        }
//                    }
//
//                    let studiumCalendar = EKCalendar(for: EKEntityType.event, eventStore: store)
//                    studiumCalendar.title = "Studium"
//                    studiumCalendar.source = store.defaultCalendarForNewEvents?.source
//                    self.defaults.setValue(studiumCalendar.calendarIdentifier, forKey: "appleCalendarID")
//                    print("Calendar Identifier: \(studiumCalendar.calendarIdentifier)")
//                    try! store.saveCalendar(studiumCalendar, commit: true)
//
////                    do{
////                    }catch error as NSError{
////                        print("Error creating Apple calendar: \(error)")
////                    }
//                }else{
//                    print("error syncing to apple calendar: \(String(describing: error))")
//                }
//            }
//        } else if cellData[indexPath.section][indexPath.row] == "Set Default Notifications" {
//
//        }
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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destinationVC = segue.destination as? AlertTableViewController {
//            destinationVC.delegate = self
//            destinationVC.setSelectedAlertOptions(alertOptions: self.databaseService.getDefaultAlertOptions())
//        }
//    }
    
    private func unwrapCoordinatorOrShowError() {
        if self.coordinator == nil {
            self.showError(.nilCoordinator)
        }
    }
}
