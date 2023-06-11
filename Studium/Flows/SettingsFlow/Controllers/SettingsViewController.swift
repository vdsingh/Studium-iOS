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

import FirebaseCrashlytics

// TODO: Docstrings
class SettingsViewController: UITableViewController, AlertTimeHandler, Storyboarded, ErrorShowing, Coordinated {
    
    // TODO: Docstrings
    private struct Constants {
        static let deleteAllAssignmentsAlertInfo = (title: "Delete All Assignments", message: "Are you sure you want to delete all assignments? You can't undo this action.")
        static let deleteCompletedAssignmentsAlertInfo = (title: "Delete Completed Assignments", message: "Are you sure you want to delete all completed assignments? You can't undo this action.")
        static let deleteAllOtherEventsAlertInfo = (title: "Delete All Other Events", message: "Are you sure you want to delete all other events? You can't undo this action.")
        static let deleteAllCompletedOtherEventsAlertInfo = (title: "Delete All Completed Other Events", message: "Are you sure you want to delete all completed other events? You can't undo this action.")
    }
    
    // TODO: Docstrings
    weak var coordinator: SettingsCoordinator?
    
    // TODO: Docstrings
    func alertTimesWereUpdated(selectedAlertOptions: [AlertOption]) {
        self.databaseService.setDefaultAlertOptions(alertOptions: selectedAlertOptions)
    }
    
    // TODO: Docstrings
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
            ("Report a Problem", didSelect: {
                self.handleReportProblem()
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
        let cellData = self.cellData[indexPath.section][indexPath.row]
        
        if let selectAction = cellData.didSelect {
            selectAction()
        }
    }
    
    
    //edit the background color of section headers
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: K.emptyHeaderHeight))
        headerView.backgroundColor = StudiumColor.background.uiColor
        return headerView
    }
    
    //TODO: Docstrings
    private func deleteAllAssignments(isCompleted: Bool) {
        let assignments = self.databaseService.getStudiumObjects(expecting: Assignment.self)
        for assignment in assignments {
            if (isCompleted && assignment.complete) || !isCompleted {
                self.databaseService.deleteStudiumObject(assignment)
            }
        }
    }
    
    //TODO: Docstrings
    private func deleteAllOtherEvents(isCompleted: Bool) {
        let otherEvents = self.databaseService.getStudiumObjects(expecting: OtherEvent.self)
        for event in otherEvents {
            if (isCompleted && event.complete) || !isCompleted {
                self.databaseService.deleteStudiumObject(event)
            }
        }
    }
    
    //TODO: Docstrings
    private func createAlertForAssignments(title: String, message: String, isCompleted: Bool){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteAllAssignments(isCompleted: isCompleted)
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
          }))

        present(refreshAlert, animated: true, completion: nil)
    }
    
    //TODO: Docstrings
    private func createAlertForOtherEvents(title: String, message: String, isCompleted: Bool){
        let refreshAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.deleteAllOtherEvents(isCompleted: isCompleted)
          }))

        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(refreshAlert, animated: true, completion: nil)
    }
    
    //TODO: Docstrings
    private func handleReportProblem() {
        let alert = UIAlertController(title: "Report a Problem", message: "Let us know how we can help.", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(
            UIAlertAction(
                title: "Send",
                style: .default,
                handler: { [weak alert] (_) in
                    if let textfield = alert?.textFields?[0],
                       let text = textfield.text,
                       !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Crashlytics.crashlytics().log("User Reported: \(text)")
                        PopUpService.shared.presentToast(title: "Message Sent", description: "Thanks for the feedback!", image: .boltLightning, popUpType: .success)
                    }
                }
            )
        )
        self.present(alert, animated: true, completion: nil)
    }
}