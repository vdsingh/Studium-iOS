//
//  StudiumEventContainer.swift
//  Studium
//
//  Created by Vikram Singh on 6/11/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation


protocol StudiumEventContainer {
    
    associatedtype ContainedEventType: StudiumEventContained
    
    //TODO: Docstrings
    var containedEvents: [ContainedEventType] { get }
    
    func appendContainedEvent(containedEvent: ContainedEventType)
}

protocol StudiumEventContained: StudiumEvent {
//    var contained: Bool { get set }
    
}
