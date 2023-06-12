//
//  StudiumEventContainer.swift
//  Studium
//
//  Created by Vikram Singh on 6/11/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation


protocol StudiumEventContainer {
    
    associatedtype ScheduledEventType: StudiumEventContained
    
    //TODO: Docstrings
    var scheduledEvents: [ScheduledEventType] { get }
    
    func appendScheduledEvent(scheduledEvent: ScheduledEventType)
}

protocol StudiumEventContained: StudiumEvent {
    
    
}
