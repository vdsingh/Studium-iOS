//
//  Autoschedulable.swift
//  Studium
//
//  Created by Vikram Singh on 6/11/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import VikUtilityKit

protocol Autoscheduling: StudiumEvent {
    
    associatedtype AutoscheduledEventType: Autoscheduled
    
    /// Whether or not this event is in charge of autoscheduling other events
    var autoscheduling: Bool { get set }
    
    /// The amount of time (in minutes) that autoscheduled events should be scheduled for
    var autoLengthMinutes: Int { get set }
    
    /// Whether we want to continuously autoschedule this event so long as it exists (otherwise, we'll use the event's endDate)
    var autoscheduleInfinitely: Bool { get set }
    
    // TODO: Docstrings
    var autoscheduledEvents: [AutoscheduledEventType] { get }
    
    //TODO: Docstrings
    func appendAutoscheduledEvent(event: AutoscheduledEventType)
    
    //TODO: Docstrings
    func instantiateAutoscheduledEvent(forTimeChunk timeChunk: TimeChunk) -> AutoscheduledEventType
    
    var autoschedulingDays: Set<Weekday> { get }
}

protocol Autoscheduled: StudiumEvent {
    
    //TODO: Docstrings
    var autoscheduled: Bool { get set }
}


