//
//  StudiumEventState.swift
//  Studium
//
//  Created by Vikram Singh on 10/7/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import ComposableArchitecture
//
// struct StudiumEventCore: Reducer {
//    struct State: Equatable {
////        var events: [StudiumEvent] = []
//        var habits: [Habit] = []
//        var courses: [Course] = []
//        var assignments: [Assignment] = []
//        var otherEvents: [OtherEvent] = []
//    }
//    
//    enum Action {
//        case addEvent(StudiumEvent)
//        case deleteEvent(StudiumEvent)
//    }
//    
//    public var body: some Reducer<State, Action> {
//        
//    }
//    
//    func reduce(into state: inout State, action: Action) -> Effect<Action> {
//        switch action {
//        case .addEvent(let studiumEvent):
////            state.events.append(studiumEvent)
//            return .none
//        case .deleteEvent(let studiumEvent):
////            state.events.removeAll(where: { $0 == studiumEvent })
//            return .none
//        }
//    }
// }

// struct StudiumEventState: ReduxState {
//    var courses: [Course] = DatabaseService.shared.getStudiumObjects(expecting: Course.self)
//    var habits: [Habit] = DatabaseService.shared.getStudiumObjects(expecting: Habit.self)
//    var assignments: [Assignment] = DatabaseService.shared.getStudiumObjects(expecting: Assignment.self)
//    var otherEvents: [OtherEvent] = DatabaseService.shared.getStudiumObjects(expecting: OtherEvent.self)
// }

// func studiumEventReducer(_ state: inout StudiumEventCore.State,
//                         _ action: StudiumEventCore.Action){
//    switch action {
//    case .addEvent(let studiumEvent):
////        state.events.append(studiumEvent)
//        break
//    case .deleteEvent(let studiumEvent):
////        state.events.removeAll(where: { $0 == studiumEvent })
//        return .
//    }
// }
