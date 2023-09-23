//
//  UserDefaultsService.swift
//  Studium
//
//  Created by Vikram Singh on 4/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

struct UserDefaultsKeys {
    static let email = "email"
    static let googleAccessTokenString = "googleAccessTokenString"
    static let googleCalendarID = "googleCalendarID"
}

//TODO: Docstring
final class UserDefaultsService {
    
    //TODO: Docstrings
    static let shared = UserDefaultsService()
    
    //TODO: Docstrings
    private init() { }
    
    //TODO: Docstrings
    private let defaults = UserDefaults.standard
    
//    private let widgetGroupDefaults = UserDefaults(suiteName: WidgetConstants.appGroupSuiteName)
    
//    func setAppleCalendarID(_ id: String) {
//        self.defaults.set(id, forKey: UserDefaultsKeys.appleCalendarID)
//    }
    
//    func getAppleCalendarID() -> String? {
//        return self.defaults.string(forKey: UserDefaultsKeys.appleCalendarID)
//    }
//    
    func setGoogleCalendarID(_ id: String?) {
        self.defaults.set(id, forKey: UserDefaultsKeys.googleCalendarID)
    }
    
    func getGoogleCalendarID() -> String? {
        return self.defaults.string(forKey: UserDefaultsKeys.googleCalendarID)
    }
    
    func setGoogleAccessTokenString(_ accessTokenString: String?) {
        self.defaults.set(accessTokenString, forKey: UserDefaultsKeys.googleAccessTokenString)
    }
    
    func getGoogleAccessTokenString() -> String? {
        return self.defaults.string(forKey: UserDefaultsKeys.googleAccessTokenString)
    }
    
    /// Stores data for the next ten assignments in UserDefaults to be used by Widgets
    /// - Parameter assignments: The next ten assignments (supplied by DatabaseService)
//    func updateNextTenAssignments(assignments: [Assignment]) {
//        let assignmentWidgetModels = assignments.map { $0.instantiateAssignmentWidgetModel() }
//        AssignmentsWidgetDataService.shared.setAssignments(assignmentWidgetModels)
//    }
}
