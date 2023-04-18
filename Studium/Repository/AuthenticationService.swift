//
//  AuthenticationService.swift
//  Studium
//
//  Created by Vikram Singh on 2/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import GoogleSignIn

//TODO: Implement
class AuthenticationService {
    static let shared = AuthenticationService()
    
    private init() {}
    
    func attemptRestorePreviousSignIn(completion: @escaping (SignInStatus) -> Void) {
        GoogleAuthenticationService.shared.attemptRestorePreviousSignIn { authStatus in
            switch authStatus {
            case .signedIn:
                completion(.signedIn)
            case .signedOut:
                completion(.signedOut)
                //TODO: Facebook Service:
//                FacebookAuthenticationService.shared.attemptRestorePreviousSignIn {
//
//                }
            }
        }
    }
}
