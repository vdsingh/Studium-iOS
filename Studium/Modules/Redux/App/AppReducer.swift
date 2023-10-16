//
//  AppReducer.swift
//  Studium
//
//  Created by Vikram Singh on 10/7/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
//
// struct _KeyPath<Root, Value> {
//    let get: (Root) -> Value
//    let set: (inout Root, Value) -> Void
// }
//
// struct EnumKeyPath<Root, Value> {
//    let embed: (Value) -> Root
//    let extract: (Root) -> Value?
// }
//
// func pullback<LocalValue, GlobalValue, LocalAction, GlobalAction>(
//    _ reducer: @escaping (inout LocalValue, LocalAction) -> Void,
//    value: WritableKeyPath<GlobalValue, LocalValue>,
//    action: WritableKeyPath<GlobalAction, LocalAction?>
// ) -> (inout GlobalValue, GlobalAction) -> Void {
//    return { globalValue, globalAction in
//        guard let localAction = globalAction[keyPath: action] else { return }
//        reducer(&globalValue[keyPath: value], localAction)
//    }
// }
//
// func combine<Value, Action>(
//    _ reducers: (inout Value, Action) -> Void...
// ) -> (inout Value, Action) -> Void {
//    return { value, action in
//        for reducer in reducers {
//            reducer(&value, action)
//        }
//    }
// }
//
// let _appReducer: (inout AppState, AppAction) -> Void = combine(
//    pullback(studiumEventReducer, value: \.self, action: \.studiumEvent)
// )
//
// let appReducer = pullback(_appReducer, value: \.self, action: \.self)
//
//
// enum AppAction {
//    case studiumEvent(StudiumEventAction)
//
//    var studiumEvent: StudiumEventAction? {
//        get {
//            guard case let .studiumEvent(value) = self else { return nil }
//            return value
//        }
//        set {
//            guard case .studiumEvent = self, let newValue = newValue else { return }
//            self = .studiumEvent(newValue)
//        }
//    }
// }
