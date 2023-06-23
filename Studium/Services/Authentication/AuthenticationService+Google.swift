//
//  AuthenticationService+Google.swift
//  Studium
//
//  Created by Vikram Singh on 6/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import GoogleSignIn

enum GoogleAuthScope {
    case calendarAPI
    
    var scopeURLString: String {
        switch self {
        case .calendarAPI:
            return "https://www.googleapis.com/auth/calendar"
        }
    }
}

// MARK: - Google Authentication

extension AuthenticationService {
    
    func handleAuthenticateWithGoogle(
        presentingViewController: UIViewController,
        scopes: [GoogleAuthScope],
        completion: @escaping (Result<GIDGoogleUser, Error>) -> Void
    ) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController,
            hint: nil,
            additionalScopes: scopes.map { $0.scopeURLString }
        ) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = signInResult else {
                completion(.failure(AuthenticationError.nilResult))
                return
            }
            
            result.user.addScopes(scopes.map({ $0.scopeURLString }), presenting: presentingViewController)
            
            self.googleAccessTokenString = result.user.accessToken.tokenString
            Log.g("successfully set the user's google authentication access token to \(result.user.accessToken.tokenString)")
            
            completion(.success(result.user))
        }
    }
    
    
    func handleLoginWithGoogle(
        presentingViewController: UIViewController,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController,
            hint: nil
        ) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = signInResult else {
                completion(.failure(AuthenticationError.nilResult))
                return
            }
                        
            guard let serverAuthCode = result.serverAuthCode else {
                completion(.failure(AuthenticationError.nilAuthCode))
                return
            }
            
            let credentials = Credentials.google(serverAuthCode: serverAuthCode)
            self.handleLogin(credentials: credentials, completion: completion)
        }
    }
    
    //TODO: Docstrings
    func attemptRestorePreviousGoogleLogin(completion: @escaping (Result<User, Error>) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                print("$ERR (GoogleAuthenticationService): error trying to restore google sign in: \(String(describing: error))")
                completion(.failure(error))
            } else if user == nil {
                // Show the app's signed-out state.
                completion(.failure(AuthenticationError.nilUser))
            } else {
                // Show the app's signed-in state.
                if let user = self.app.currentUser {
                    completion(.success(user))
                } else {
                    completion(.failure(AuthenticationError.nilUser))
                }
            }
        }
    }
}
