//
//  AppCore.swift
//  Studium
//
//  Created by Vikram Singh on 10/8/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import ComposableArchitecture
//
// public struct Studium: Reducer {
//    public enum State: Equatable {
//        case authentication(Authentication.State)
//        case studiumEvents(StudiumEvents.State)
//        
//        public init() { self = .authentication(Authentication.State()) }
//    }
//    
//    public enum Action: Equatable {
//        case authentication(Authentication.Action)
//        case studiumEvents(StudiumEvents.Action)
//    }
//    
//    public init() {}
//    
//    public var body: some Reducer<State, Action> {
//        Reduce { state, action in
//            switch action {
//            case .login(.twoFactor(.presented(.twoFactorResponse(.success)))):
//                state = .newGame(NewGame.State())
//                return .none
//                
//            case let .login(.loginResponse(.success(response))) where !response.twoFactorRequired:
//                state = .newGame(NewGame.State())
//                return .none
//                
//            case .login:
//                return .none
//                
//            case .newGame(.logoutButtonTapped):
//                state = .login(Login.State())
//                return .none
//                
//            case .newGame:
//                return .none
//            }
//        }
//        .ifCaseLet(/State.login, action: /Action.login) {
//            Login()
//        }
//        .ifCaseLet(/State.newGame, action: /Action.newGame) {
//            NewGame()
//        }
//    }
// }
