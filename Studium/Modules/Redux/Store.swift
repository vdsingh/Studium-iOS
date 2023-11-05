//
//  Store.swift
//  Studium
//
//  Created by Vikram Singh on 10/7/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import SwiftUI

// final class Store<State: ReduxState, Action>: ObservableObject {
//    
////    let sharedStore: Store = Store(reducer: appReducer, state: AppState())
//    
//    var reducer: (_ state: inout State, _ action: Action) -> Void
//    @Published var state: State
//    var middlewares: [Middleware<State>]
//    
//    init(reducer: @escaping (_ state: inout State, _ action: Action) -> Void,
//         state: State,
//         middlewares: [Middleware<State>] = []) {
//        self.reducer = reducer
//        self.state = state
//        self.middlewares = middlewares
//    }
//    
//    func send(_ action: Action) {
//        self.reducer(&self.state, action)
//    }
// }

final class Store<Value, Action>: ObservableObject {
  let reducer: (inout Value, Action) -> Void
  @Published private(set) var value: Value

  init(initialValue: Value, reducer: @escaping (inout Value, Action) -> Void) {
    self.reducer = reducer
    self.value = initialValue
  }

  func send(_ action: Action) {
    self.reducer(&self.value, action)
  }
}
