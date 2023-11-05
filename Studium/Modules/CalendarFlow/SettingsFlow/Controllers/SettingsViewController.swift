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
import EventKit

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
    }
    
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
