//
//  Weekday.swift
//  
//
//  Created by Vikram Singh on 5/14/23.
//

import Foundation

//TODO: Docstrings
public enum Weekday: Int, CaseIterable {
    
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case unknown = -1
    
    //TODO: Docstrings
    static var buttonTextMap: [String: Int] {
        return ["Sun": 1, "Mon": 2, "Tue": 3, "Wed": 4, "Thu": 5, "Fri": 6, "Sat": 7]
    }
    
    public static var allKnownCases: [Weekday] {
        Weekday.allCases.filter{ $0 != .unknown }
    }
    
    //TODO: Docstrings
    public var buttonText: String {
        switch self {
        case .sunday:
            return "Sun"
        case .monday:
            return "Mon"
        case .tuesday:
            return "Tue"
        case .wednesday:
            return "Wed"
        case .thursday:
            return "Thu"
        case .friday:
            return "Fri"
        case .saturday:
            return "Sat"
        case .unknown:
            return "Unk"
        }
    }
    
    public var rfc5545Value: String {
        var buttonText = self.buttonText
        buttonText.removeLast()
        return buttonText.uppercased()
    }
    
    //TODO: Docstrings
    public init(buttonText: String) {
        if Weekday.buttonTextMap.keys.contains(buttonText) {
            self.init(rawValue: Weekday.buttonTextMap[buttonText]!)!
        } else {
            Log.e("tried to construct a weekday from buttonText: \(buttonText), which doesn't correspond to a Weekday case.")
            self = .unknown
        }
    }
}
