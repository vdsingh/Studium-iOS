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


struct SettingsCell: View {
    
    private var icon: UIImage?
    private var iconRenderingMode: Image.TemplateRenderingMode = .template
    private var text: String
    private var subText: String?
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
                    
                    VStack(alignment: .leading) {
                        StudiumText(self.text)
                        if let subText = self.subText, !subText.trimmed().isEmpty {
                            StudiumSubtext(subText)
                        }
                    }
                }
            }
        }
    }
    
    init(icon: UIImage,
         text: String,
         subText: String? = nil,
         onClick: @escaping (SettingsCell) -> Void) {
        self.icon = icon
        self.subText = subText
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

import EventKit
struct SettingsView: View {
    let authenticationService: AuthenticationService = .shared
    let databaseService: DatabaseService = .shared
    let studiumEventService: StudiumEventService = .shared
    let presentingViewController: UIViewController
    let alertTimeDelegate: AlertTimeHandler
    
    @ObservedObject var appleCalendarService = AppleCalendarService.shared
//    var appleCalendarIsAuthorized: Binding<Bool> {
//        return self.appleCalendarService.isAuthorized
//    }
//    var appleCalendarIsAuthorized: Bool { self.appleCalendarService.isAuthorized }
//    var appleCalendarIsSynced: Bool { self.appleCalendarService.isSynced }
    
    weak var coordinator: SettingsCoordinator?
    
    var body: some View {
//        NavigationView {
            List {
                Section("Calendar Sync") {
                    if self.appleCalendarService.isSynced {
                        SettingsCell(icon: SystemIcon.appleLogo.uiImage, text: "Unsync Apple Calendar", subText: "\(self.appleCalendarService.totalEventCount) Apple Calendar Events") { cell in
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
//    }
}

class SettingsViewController: SwiftUIViewController<SettingsView> {
    weak var coordinator: SettingsCoordinator?
    let databaseService: DatabaseService
    
    lazy var settingsView = SettingsView(
        presentingViewController: self,
        alertTimeDelegate: self,
        coordinator: self.coordinator
    )
            

    init(coordinator: SettingsCoordinator?, databaseService: DatabaseService) {
        self.coordinator = coordinator
        self.databaseService = databaseService
        super.init()
    }
    
    override func loadView() {
        super.loadView()
        self.setupSwiftUI(withView: self.settingsView)
        self.title = "Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.addToolBarButtons(
//            left: UIBarButtonItem(image: <#T##UIImage?#>, style: <#T##UIBarButtonItem.Style#>, target: <#T##Any?#>, action: <#T##Selector?#>),
//            right: UIBarButtonItem(image: <#T##UIImage?#>, style: <#T##UIBarButtonItem.Style#>, target: <#T##Any?#>, action: <#T##Selector?#>)
//        )
    }
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.navigationBar.prefersLargeTitles = false
//    }
    
//    private func setupSwiftUI() {
//
//        let hostingController = UIHostingController(rootView: settingsView)
//        self.addChild(hostingController)
//        self.view.addSubview(hostingController.view)
//        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
//            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsViewController: AlertTimeHandler {
    
    // TODO: Docstrings
    func alertTimesWereUpdated(selectedAlertOptions: [AlertOption]) {
        self.databaseService.setDefaultAlertOptions(alertOptions: selectedAlertOptions)
    }
}

//struct SettingsPreview: PreviewProvider {
//    static var previews: some View {
//        SettingsView(presentingViewController: UIViewController(), alertTimeDelegate: nil)
//    }
//}
