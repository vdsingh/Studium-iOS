//
//  Autoschedulable.swift
//  Studium
//
//  Created by Vikram Singh on 6/11/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

// TODO: Docstrings
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
