//
//  UserDefaultsService.swift
//  Studium
//
//  Created by Vikram Singh on 4/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation



//TODO: Docstring
final class UserDefaultsService {
    
    private enum Keys: String {
        case appleCalendarID
        case email
        case googleAccessTokenString
        case googleCalendarID
    }
    
    //TODO: Docstrings
    static let shared = UserDefaultsService()
    
    //TODO: Docstrings
    private init() { }
    
    //TODO: Docstrings
    private let defaults = UserDefaults.standard
    
    private let widgetGroupDefaults = UserDefaults(suiteName: WidgetConstants.appGroupSuiteName)
    
    func setAppleCalendarID(_ id: String) {
        self.defaults.set(id, forKey: Keys.appleCalendarID.rawValue)
    }
    
    func getAppleCalendarID() -> String? {
        return self.defaults.string(forKey: Keys.appleCalendarID.rawValue)
    }
    
    func setGoogleCalendarID(_ id: String?) {
        self.defaults.set(id, forKey: Keys.googleCalendarID.rawValue)
    }
    
    func getGoogleCalendarID() -> String? {
        return self.defaults.string(forKey: Keys.googleCalendarID.rawValue)
    }
    
    func setGoogleAccessTokenString(_ accessTokenString: String?) {
        self.defaults.set(accessTokenString, forKey: Keys.googleAccessTokenString.rawValue)
    }
    
    func getGoogleAccessTokenString() -> String? {
        return self.defaults.string(forKey: Keys.googleAccessTokenString.rawValue)
    }
    
    /// Stores data for the next ten assignments in UserDefaults to be used by Widgets
    /// - Parameter assignments: The next ten assignments (supplied by DatabaseService)
    func updateNextTenAssignments(assignments: [Assignment]) {
        let assignmentWidgetModels = assignments.map { $0.instantiateAssignmentWidgetModel() }
        AssignmentsWidgetDataService.shared.setAssignments(assignmentWidgetModels)
    }
}
