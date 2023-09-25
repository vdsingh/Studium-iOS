//
//  SettingsView.swift
//  Studium
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    let authenticationService: AuthenticationService = .shared
    let databaseService: DatabaseService = .shared
    let studiumEventService: StudiumEventService = .shared
    let presentingViewController: UIViewController
    let alertTimeDelegate: AlertTimeHandler
    
    @ObservedObject var appleCalendarService = AppleCalendarService.shared
    
    weak var coordinator: SettingsCoordinator?
    
    var body: some View {
        List {
            Section("Calendar Sync") {
                if self.appleCalendarService.isSynced {
                    SettingsCell(icon: SystemIcon.appleLogo.uiImage,
                                 iconColor: StudiumColor.primaryLabel.uiColor,
                                 text: "Unsync Apple Calendar",
                                 subText: "\(self.appleCalendarService.totalEventCount) Apple Calendar Events")
                    { cell in
                        self.appleCalendarService.unsyncCalendar {
                            cell.loading = false
                        }
                    }
                } else {
                    SettingsCell(icon: SystemIcon.appleLogo, text: "Sync Apple Calendar") { cell in
                        self.appleCalendarService.syncCalendar { _ in
                            cell.loading = false
                        }
                    }
                }
                
                SettingsCell(icon: ThirdPartyIcon.googleCalendar, iconRenderingMode: .original, text: "Sync Google Calendar") { cell in
                    GoogleCalendarService.shared.authenticateWithCalendarScope(
                        presentingViewController: self.presentingViewController
                    )
                    cell.loading = false
                }
            }
            
            Section("Defaults") {
                SettingsCell(icon: StudiumIcon.bell, text: "Default Notification Settings") { cell in
                    cell.loading = false
                    guard let coordinator = self.coordinator else {
                        Log.e("Coordinator was nil")
                        PopUpService.presentGenericError()
                        return
                    }
                    
                    coordinator.showAlertTimesSelectionViewController(
                        updateDelegate: self.alertTimeDelegate,
                        selectedAlertOptions: self.databaseService.getDefaultAlertOptions(),
                        viewControllerTitle: "Default Notifications"
                    )
                }
                
                SettingsCell(icon: SystemIcon.sunMax.createImage(), text: "Reset Wake-Up Times") { cell in
                    cell.loading = false
                    guard let coordinator = self.coordinator else {
                        Log.e("Coordinator was nil")
                        PopUpService.presentGenericError()
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
                    PopUpService.presentDeleteAlert {
                        let otherEvents = self.databaseService.getStudiumObjects(expecting: OtherEvent.self)
                        for event in otherEvents {
                            self.studiumEventService.deleteStudiumEvent(event)
                        }
                    }
                }
                
                SettingsCell(icon: SystemIcon.trashCan.createImage(), text: "Delete all Completed To-Do Events") { cell in
                    cell.loading = false
                    PopUpService.presentDeleteAlert {
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
                    PopUpService.showForm(formType: .reportAProblem) { textContents in
                        if let email = textContents.first,
                           let problemDetails = textContents.last {
                            if problemDetails.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                PopUpService.presentToast(title: "Error Reporting Problem", description: "Please specify the problem details.", popUpType: .failure)
                            } else {
                                PopUpService.presentToast(title: "Message Sent", description: "Thanks for the feedback!", popUpType: .success)
                                CrashlyticsService.shared.reportAProblem(email: email, message: problemDetails)
                            }
                        }
                    }
                }
            }
            
            Section("Account") {
                SettingsCell(icon: StudiumIcon.user, text: self.authenticationService.userEmail ?? "Guest") { cell in
                    cell.loading = false
                }
                
                SettingsCell(text: "Sign Out") { cell in
                    AuthenticationService.shared.handleLogOut { error in
                        cell.loading = false
                        if let error {
                            Log.e(error)
                            PopUpService.presentToast(title: "Error Logging Out",
                                                      description: "Try restarting the app.",
                                                      popUpType: .failure)
                            return
                        }
                        
                        guard let coordinator = self.coordinator else {
                            Log.e("Coordinator was nil")
                            PopUpService.presentGenericError()
                            return
                        }
                        
                        coordinator.showAuthenticationFlow()
                    }
                }
            }
        }
        .environment(\.defaultMinListRowHeight, Increment.ten)
        .navigationTitle("Settings")
    }
}
