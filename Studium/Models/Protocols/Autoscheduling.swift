//
//  Autoschedulable.swift
//  Studium
//
//  Created by Vikram Singh on 6/11/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

protocol Autoscheduling: StudiumEvent {
    
    associatedtype AutoscheduledEventType: Autoscheduled & Codable
    
    var autoschedulingConfigData: Data? { get set }
        
    var autoscheduledEventsList: List<AutoscheduledEventType> { get set }
    
    //TODO: Docstrings
    func instantiateAutoscheduledEvent(forTimeChunk timeChunk: TimeChunk) -> AutoscheduledEventType
}

extension Autoscheduling {
    var autoscheduling: Bool {
        return self.autoschedulingConfig != nil
    }
    
    var autoschedulingConfig: AutoschedulingConfig? {
        get {
            if let data = self.autoschedulingConfigData {
                return try? JSONDecoder().decode(AutoschedulingConfig.self, from: data)
            }
            return nil
        }
        
        set {
            self.autoschedulingConfigData = try? JSONEncoder().encode(newValue)
        }
    }
    
    var autoscheduledEvents: [AutoscheduledEventType] {
        get { return [AutoscheduledEventType](self.autoscheduledEventsList) }
        set {
            let list = List<AutoscheduledEventType>()
            list.append(objectsIn: newValue)
            self.autoscheduledEventsList = list
        }
    }
    
    func appendAutoscheduledEvent(event: AutoscheduledEventType) {
        self.autoscheduledEvents.append(event)
    }
}

struct AutoschedulingConfig: Codable {
    
    /// The amount of time (in minutes) that autoscheduled events should be scheduled for
    var autoLengthMinutes: Int
    
    /// Whether we want to continuously autoschedule this event so long as it exists (otherwise, we'll use the event's endDate)
    var autoscheduleInfinitely: Bool
    
    // TODO: Docstrings
    var useDatesAsBounds: Bool
    
    private var autoschedulingDaysList = List<Int>()
    
    var autoschedulingDays: Set<Weekday> {
        get {
            return Set<Weekday>( self.autoschedulingDaysList.compactMap { Weekday(rawValue: $0) })
        }
        set {
            Log.d("newValue: \(newValue)")
            let list = List<Int>()
            list.append(objectsIn: newValue.compactMap({ $0.rawValue }))
            self.autoschedulingDaysList = list
            Log.d("End Result \(self.autoschedulingDaysList)")
        }
    }
    
    init(autoLengthMinutes: Int, autoscheduleInfinitely: Bool, useDatesAsBounds: Bool, autoschedulingDays: Set<Weekday>) {
        self.autoLengthMinutes = autoLengthMinutes
        self.autoscheduleInfinitely = autoscheduleInfinitely
        self.useDatesAsBounds = useDatesAsBounds
        self.autoschedulingDays = autoschedulingDays
    }
}
