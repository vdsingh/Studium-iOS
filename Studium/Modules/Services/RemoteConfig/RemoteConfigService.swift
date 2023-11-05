//
//  RemoteConfigService.swift
//  Studium
//
//  Created by Vikram Singh on 9/30/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
import FirebaseRemoteConfig

/// Boolean flags from Remote Config
enum ServerFlags: String, CaseIterable {
    
    // MARK: - Autoscheduling Related
    case allowHabitAutoscheduling
    case allowAssignmentAutoscheduling
    case enableHabitAutoschedulingByDefault
    case enableAssignmentAutoschedulingByDefault
    
    
    case allowGoogleCalendarSync
    case allowAppleCalendarSync
    
    // MARK: - Computed Properties
    
    /// The value of the flag
    var value: Bool {
        let value = Self.retrieveValue(forKey: self.rawValue)
        Log.d("Retrieved flag \(self.rawValue) with value \(value.boolValue). The source was \(value.source)")
        return value.boolValue
    }
    
    /// What the flag defaults to if it couldn't be retrieved from the server
    private var fallbackValue: Bool {
        switch self {
        case .allowHabitAutoscheduling:
            return true
        case .allowAssignmentAutoscheduling:
            return true
        case .enableHabitAutoschedulingByDefault:
            return false
        case .enableAssignmentAutoschedulingByDefault:
            return false
        case .allowGoogleCalendarSync:
            return true
        case .allowAppleCalendarSync:
            return true
        }
    }
    
    // MARK: - Helper Functions
    private static func retrieveValue(forKey key: String) -> RemoteConfigValue {
        return RemoteConfigService.shared.remoteConfig.configValue(forKey: key)
    }
    
    fileprivate static var defaults: [String: NSObject] {
        var map = [String: NSObject]()
        for flag in ServerFlags.allCases {
            map[flag.rawValue] = NSNumber(booleanLiteral: flag.fallbackValue)
        }
        
        return map
    }
}

class RemoteConfigService {
    static let shared = RemoteConfigService()
    var remoteConfig: RemoteConfig
    
    private init() {
        self.remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        self.remoteConfig.configSettings = settings
        self.remoteConfig.setDefaults(ServerFlags.defaults)
    }
    
    func refresh(completion: @escaping () -> Void) {
        self.remoteConfig.fetchAndActivate() { (status, error) -> Void in
            if status == .successFetchedFromRemote || status == .successUsingPreFetchedData {
                Log.g("Remote Config fetched successfully")
            } else {
                if let error {
                    Log.e(error, additionalDetails: "Remote config could not be fetched")
                } else {
                    Log.e("Remote config could not be fetched. No error available")
                }
            }
            
            completion()
        }
    }
}
