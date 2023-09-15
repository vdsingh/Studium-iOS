//
//  CrashlyticsService.swift
//  Studium
//
//  Created by Vikram Singh on 6/10/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import FirebaseCrashlytics

// TODO: Docstrings
struct CrashlyticsService {
    
    static let shared = CrashlyticsService()
    
    private init() { }
    
    func setUserID() {
        Crashlytics.crashlytics().setUserID(AuthenticationService.shared.userID ?? "")
    }
    
    func recordError(_ error: Error, additionalDetails: String) {
        self.setUserID()
        let userInfo = [
            NSLocalizedDescriptionKey: NSLocalizedString("Additional Details: \(additionalDetails)", comment: "")
        ]
                
        Crashlytics.crashlytics().record(error: error, userInfo: userInfo)
    }
    
    func log(_ message: String) {
        self.setUserID()
        Crashlytics.crashlytics().log(message)
    }
    
    func reportAProblem(email: String?, message: String) {
        self.setUserID()
        Crashlytics.crashlytics().setCustomValue(email, forKey: "Email")
        Crashlytics.crashlytics().setCustomValue(message, forKey: "ProblemReport")
        Crashlytics.crashlytics().record(error: ReportProblemError.reportAProblem)
    }
}

enum ReportProblemError: Error {
    case reportAProblem
}
