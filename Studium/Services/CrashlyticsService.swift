//
//  CrashlyticsService.swift
//  Studium
//
//  Created by Vikram Singh on 6/10/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

struct CrashlyticsService {
    static let shared = CrashlyticsService()
    
    private init() {}
    
    private func setUserID() {
        Crashlytics.crashlytics().setUserID(AuthenticationService.shared.userID ?? "")
    }
    
    func recordError(_ error: Error, additionalDetails: String) {
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Additional Details: \(additionalDetails)", comment: "")
        ]
                
        Crashlytics.crashlytics().record(error: error, userInfo: userInfo)
    }
}
