//
//  NewSettingsViewController.swift
//  Studium
//
//  Created by Vikram Singh on 9/9/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
import VikUtilityKit

struct SettingsCell: View {
    
    private var icon: UIImage?
    private var iconRenderingMode: Image.TemplateRenderingMode = .template
    private var text: String
    private var onClick: (SettingsCell) -> Void
    @State var loading: Bool = false
    
    var body: some View {
        Button {
            self.loading = true
            self.onClick(self)
        } label: {
            if self.loading {
                HStack(spacing: Increment.two) {
                    Spacer()
                    Spinner()
                        .frame(height: Increment.six)
                    Spacer()
                }
            } else {
                HStack {
                    if let icon = self.icon {
                        SmallIcon(image: icon, renderingMode: self.iconRenderingMode)
                    }
                    
                    StudiumText(self.text)
                }
            }
        }
    }
    
    init(icon: UIImage,
         text: String,
         onClick: @escaping (SettingsCell) -> Void
    ) {
        self.icon = icon
        self.text = text
        self.onClick = onClick
    }
    
    init(
        icon: any CreatesUIImage,
        iconRenderingMode: Image.TemplateRenderingMode = .template,
        text: String,
        onClick: @escaping (SettingsCell) -> Void
    ) {
        self.init(icon: icon.uiImage, text: text, onClick: onClick)
        self.iconRenderingMode = iconRenderingMode
    }
    
    init(text: String, onClick: @escaping (SettingsCell) -> Void) {
        self.icon = nil
        self.text = text
        self.onClick = onClick
    }
}

struct SettingsView: View {
    let databaseService: DatabaseService = .shared
    let studiumEventService: StudiumEventService = .shared
    let presentingViewController: UIViewController
    let alertTimeDelegate: AlertTimeHandler
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

    var body: some View {
        NavigationView {
            List {
                Section("Calendar Sync") {
                    SettingsCell(icon: ThirdPartyIcon.appleCalendar, iconRenderingMode: .original, text: "Sync with Apple Calendar") { cell in
                        AppleCalendarService.shared.syncCalendar { _ in
                            cell.loading = false
                        }
                    }
                    
                    SettingsCell(icon: ThirdPartyIcon.googleCalendar, iconRenderingMode: .original, text: "Sync with Google Calendar") { cell in
                        GoogleCalendarService.shared.authenticateWithCalendarScope(
                            presentingViewController: self.presentingViewController
                        )
                        cell.loading = false
                    }
                }
                
                Section("Defaults") {
                    SettingsCell(icon: StudiumIcon.bell, text: "Default Reminders Settings") { cell in
                        cell.loading = false
                        guard let coordinator = self.coordinator else {
                            Log.e("Coordinator was nil")
                            PopUpService.shared.presentGenericError()
                            return
                        }
                        
                        coordinator.showAlertTimesSelectionViewController(
                            updateDelegate: self.alertTimeDelegate,
                            selectedAlertOptions: self.databaseService.getDefaultAlertOptions(),
                            viewControllerTitle: "Default Notifications"
                        )
                    }
                    
                    SettingsCell(icon: SystemIcon.sunMax.createImage(), text: "Reset Wake Up Times") { cell in
                        cell.loading = false
                        guard let coordinator = self.coordinator else {
                            Log.e("Coordinator was nil")
                            PopUpService.shared.presentGenericError()
                            return
                        }
                        
                        coordinator.showUserSetupFlow()
                    }
                }
                
                Section("Quick Delete") {
                    SettingsCell(icon: SystemIcon.trashCan.createImage(), text: "Delete all Assignments") { cell in
                        cell.loading = false
                        let assignments = self.databaseService.getStudiumObjects(expecting: Assignment.self)
                        for assignment in assignments {
                                self.studiumEventService.deleteStudiumEvent(assignment)
                        }
                    }
                    
                    SettingsCell(icon: SystemIcon.trashCan.createImage(), text: "Delete Completed Assignments") { cell in
                        cell.loading = false
                        let assignments = self.databaseService.getStudiumObjects(expecting: Assignment.self)
                        for assignment in assignments {
                            if assignment.complete {
                                self.studiumEventService.deleteStudiumEvent(assignment)
                            }
                        }
                    }
                    
                    SettingsCell(icon: SystemIcon.trashCan.createImage(), text: "Delete all To-Do Events") { cell in
                        cell.loading = false
                        PopUpService.shared.presentDeleteAlert {
                            let otherEvents = self.databaseService.getStudiumObjects(expecting: OtherEvent.self)
                            for event in otherEvents {
                                self.studiumEventService.deleteStudiumEvent(event)
                            }
                        }
                    }
                    
                    SettingsCell(icon: SystemIcon.trashCan.createImage(), text: "Delete all Completed To-Do Events") { cell in
                        cell.loading = false
                        PopUpService.shared.presentDeleteAlert {
                            let otherEvents = self.databaseService.getStudiumObjects(expecting: OtherEvent.self)
                            for event in otherEvents {
                                if event.complete {
                                    self.studiumEventService.deleteStudiumEvent(event)
                                }
                            }
                        }
                    }
                }
                
                Section("Feedback") {
                    SettingsCell(icon: StudiumIcon.bug, text: "Report a Problem") { cell in
                        cell.loading = false
                        PopUpService.shared.showForm(formType: .reportAProblem) { textContents in
                            if let email = textContents.first,
                               let problemDetails = textContents.last {
                                if problemDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    PopUpService.shared.presentToast(title: "Error Reporting Problem", description: "Please specify the problem details.", popUpType: .failure)
                                } else {
                                    PopUpService.shared.presentToast(title: "Message Sent", description: "Thanks for the feedback!", popUpType: .success)
                                    CrashlyticsService.shared.reportAProblem(email: email, message: problemDetails)
                                }
                            }
                        }
                    }
                }
                
                Section("Account") {
                    SettingsCell(icon: StudiumIcon.user, text: "Email") { cell in
                        cell.loading = false
>>>>>>> Stashed changes
                    }
                    
                    SettingsCell(text: "Sign Out") { cell in
                        AuthenticationService.shared.handleLogOut { error in
                            cell.loading = false
                            if let error {
                                Log.e(error)
                                PopUpService.shared.presentToast(title: "Error Logging Out",
                                                                 description: "Try restarting the app.",
                                                                 popUpType: .failure)
                                return
                            }
                            
                            guard let coordinator = self.coordinator else {
                                Log.e("Coordinator was nil")
                                PopUpService.shared.presentGenericError()
                                return
                            }
                            
                            coordinator.showAuthenticationFlow()
                        }
                    }
                }
<<<<<<< Updated upstream
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
=======
>>>>>>> Stashed changes
            }
            .environment(\.defaultMinListRowHeight, Increment.ten)
            .navigationTitle("Settings")
        }
    }
}

class SettingsViewController: UIViewController {
    weak var coordinator: SettingsCoordinator?
    let databaseService: DatabaseService

    init(coordinator: SettingsCoordinator?, databaseService: DatabaseService) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSwiftUI()
        self.navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupSwiftUI() {
        let settingsView = SettingsView(
            presentingViewController: self,
            alertTimeDelegate: self,
            coordinator: self.coordinator
        )
        
        let hostingController = UIHostingController(rootView: settingsView)
        self.addChild(hostingController)
        self.view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
<<<<<<< Updated upstream
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
=======
        hostingController.didMove(toParent: self)
>>>>>>> Stashed changes
    }
}

extension SettingsViewController: AlertTimeHandler {
    // TODO: Docstrings
    func alertTimesWereUpdated(selectedAlertOptions: [AlertOption]) {
        self.databaseService.setDefaultAlertOptions(alertOptions: selectedAlertOptions)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    
//    static var weekdays: Set<Weekday> {
//        var set = Set<Weekday>()
//        set.insert(.wednesday)
//        set.insert(.monday)
//        return set
//    }
//    
//    static let mockAssignment = Assignment(name: "Homework 4", additionalDetails: "Additional Details", complete: true, startDate: Date(), endDate: Date()+100000, notificationAlertTimes: [], autoschedulingConfig: nil, parentCourse: Course(name: "CS 320", location: "Building A", additionalDetails: "Hello World", startDate: Date(), endDate: Date(), color: .green, icon: .atom, alertTimes: []))
//    
//    static var previews: some View {
//        AssignmentView(
//            assignment: mockAssignment,
//            pdfUrlWasPressed: { _ in }
//        )
//    }
//}
