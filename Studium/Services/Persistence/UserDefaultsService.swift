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
    
//    func wakeUpTime(for day: Date) {
//        if let
//        return day.setTime(hour: <#T##Int#>, minute: <#T##Int#>, second: <#T##Int#>)
//    }
    
//    let wakeUpTime = UserDefaults.standard.array(forKey: K.wakeUpKeyDict[date.weekday]!)![0] as! Date
//    let startBound = date.setTime(hour: wakeUpTime.hour, minute: wakeUpTime.minute, second: 0) ?? Date()
//    let endBound = date.setTime(hour: 23, minute: 59, second: 0) ?? Date()
}
