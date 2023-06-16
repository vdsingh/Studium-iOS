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
import TableViewFormKit

import FirebaseCrashlytics

// TODO: Docstrings
class SettingsViewController: TableViewForm, Storyboarded, ErrorShowing, Coordinated, Debuggable {
    
    let debug = true
    
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
    var databaseService: DatabaseServiceProtocol! = DatabaseService.shared
    
    //TODO: Docstrings
    lazy var cellData: [[(text: String, icon: StudiumIcon?, didSelect: (() -> Void)?)]] = [
        [
            ("Set Default Notifications", .bell, didSelect: {
                self.unwrapCoordinatorOrShowError()
                self.coordinator?.showAlertTimesSelectionViewController(
                    updateDelegate: self,
                    selectedAlertOptions: self.databaseService.getDefaultAlertOptions(),
                    viewControllerTitle: "Default Notifications"
                )
            }),
            ("Reset Wake Up Times", .clock, didSelect: {
                self.unwrapCoordinatorOrShowError()
                self.coordinator?.showUserSetupFlow()
            })
        ],
        [
            ("Delete All Assignments", nil, didSelect: {
                self.createAlertForAssignments(title: Constants.deleteAllAssignmentsAlertInfo.title, message: Constants.deleteAllAssignmentsAlertInfo.message, isCompleted: false)
            }),
            ("Delete Completed Assignments", nil, didSelect: {
                self.createAlertForAssignments(title: Constants.deleteCompletedAssignmentsAlertInfo.title, message: Constants.deleteCompletedAssignmentsAlertInfo.message, isCompleted: true)
            }),
            ("Delete All Other Events", nil, didSelect: {
                self.createAlertForOtherEvents(title: Constants.deleteAllOtherEventsAlertInfo.title, message: Constants.deleteAllOtherEventsAlertInfo.message, isCompleted: false)
            }),
            ("Delete All Completed Other Events", nil, didSelect: {
                self.createAlertForOtherEvents(title: Constants.deleteAllCompletedOtherEventsAlertInfo.title, message: Constants.deleteAllCompletedOtherEventsAlertInfo.message, isCompleted: true)
                
            })
        ],
        
        [
            ("Report a Problem", .bug, didSelect: {
                PopUpService.shared.showForm(formType: .reportAProblem) { textContents in
                    if let email = textContents.first,
                    let problemDetails = textContents.last {
                        if problemDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            PopUpService.shared.presentToast(title: "Error Reporting Problem", description: "Please specify the problem details.", popUpType: .failure)
                        } else {
                            PopUpService.shared.presentToast(title: "Message Sent", description: "Thanks for the feedback!", popUpType: .success)
                            CrashlyticsService.shared.reportAProblem(email: email, message: problemDetails)
                            self.printDebug("sent message with email: \(email), problem details: \(problemDetails)")
                        }
                    }
                }
            })
        ],
        [
            ("ID: \(AuthenticationService.shared.userID ?? "Guest")", .user, nil),
            ("Sign Out", .rightFromBracket, didSelect: {
                AuthenticationService.shared.handleLogOut { error in
                    if let error = error {
                        Log.e(error)
                        PopUpService.shared.presentToast(title: "Error Logging Out", description: "Try restarting the app.", popUpType: .failure)
                        return
                    }
                    
                    self.unwrapCoordinatorOrShowError()
                    self.coordinator?.showAuthenticationFlow()
                }
            })
            
        ]
    ]
    
    func setCells() {
        self.cells = cellData.map({ sectionData in
            return sectionData.map { cellData in
                // cellData format: (text: String, didSelect: (() -> Void)?)
                return .labelCell(
                    cellText: cellData.text,
                    icon: cellData.icon?.image,
                    onClick: cellData.didSelect
                )
            }
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCells()
        self.tableView.tableFooterView = UIView()
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: StudiumColor.primaryLabel.uiColor]
        self.navigationController?.navigationBar.tintColor = StudiumColor.primaryAccent.uiColor
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        self.view.backgroundColor = StudiumColor.background.uiColor
        self.navigationController?.navigationBar.barTintColor = StudiumColor.background.uiColor
    }
    
    //TODO: Docstrings
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//        cell?.backgroundColor = StudiumColor.secondaryBackground.uiColor
//        cell?.textLabel?.textColor = StudiumColor.primaryLabel.uiColor
//        cell?.textLabel?.text = cellData[indexPath.section][indexPath.row].text
//        
//        let id = AuthenticationService.shared.userID
//        if cellData[indexPath.section][indexPath.row].text == "Email" {
//            cell?.textLabel?.text = id
//        }
//        
//        return cell!
//    }
    
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
        
        tableView.deselectRow(at: indexPath, animated: true)
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
}

extension SettingsViewController: AlertTimeHandler {
    // TODO: Docstrings
    func alertTimesWereUpdated(selectedAlertOptions: [AlertOption]) {
        self.databaseService.setDefaultAlertOptions(alertOptions: selectedAlertOptions)
    }
}
