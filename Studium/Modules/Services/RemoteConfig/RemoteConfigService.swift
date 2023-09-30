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

//if Flags.allowHabitAutoscheduling {
//...
//}

enum Flags: String, CaseIterable {
    // MARK: - Booleans
    case allowHabitAutoscheduling
    
    var value: Bool {
        let value = Self.retrieveValue(forKey: self.rawValue)
        Log.d("Retrieved flag \(self.rawValue) with value \(value.boolValue). The source was \(value.source)")
        return value.boolValue
    }
    
    /// Whether the flag should be enabled by default
    var enabledByDefault: Bool {
        switch self {
        case .allowHabitAutoscheduling:
            return true
        }
    }
    
    // MARK: - Helper Functions
    private static func retrieveValue(forKey key: String) -> RemoteConfigValue {
        return RemoteConfigService.shared.remoteConfig.configValue(forKey: key)
    }
    
    fileprivate static var defaults: [String: NSObject] {
        var map = [String: NSObject]()
        for flag in Flags.allCases {
            map[flag.rawValue] = NSNumber(booleanLiteral: flag.enabledByDefault)
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
        self.remoteConfig.setDefaults(Flags.defaults)
    }
    
    func refresh(completion: @escaping () -> Void) {
        self.remoteConfig.fetch { (status, error) -> Void in
            if status == .success {
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
