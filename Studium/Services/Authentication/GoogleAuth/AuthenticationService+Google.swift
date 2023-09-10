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

// MARK: - Google Authentication

extension AuthenticationService {
    
    func addScopes(
        scopes: [GoogleAuthScope],
        toUser user: GIDGoogleUser,
        presentingViewController: UIViewController
    ) {
        let scopeStrings = scopes.map { $0.scopeURLString }
        user.addScopes(scopeStrings, presenting: presentingViewController) { signInResult, error in
            if let error = error {
                GoogleSignInErrorCode.extractErrorCode(from: String(describing: error.localizedDescription)).showPopUpToUser()
                Log.e(error)
            } else if let signInResult = signInResult {
                Log.g("Successfully added google scopes to user. Result \(signInResult)")
            } else {
                PopUpService.shared.presentToast(title: "Error adding scope to Google User", description: "signInResult was nil", popUpType: .failure)
                Log.e(AuthenticationError.nilResult)
            }
        }
    }
    
    func authenticateWithGoogle(
        withScopes scopes: [GoogleAuthScope],
        presentingViewController: UIViewController,
        completion: @escaping (Result<GIDGoogleUser, Error>) -> Void
    ) {
        
        // There already is a google user signed in. Launch add scopes flow
        if let user = GIDSignIn.sharedInstance.currentUser {
            self.addScopes(scopes: scopes, toUser: user, presentingViewController: presentingViewController)
            completion(.success(user))
        }
        
        // A google user has previously signed in. Restore sign in and then launch add scopes flow
        else if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn() { user, error in
                // TODO: Handle error (present to user)
                if let error = error {
                    completion(.failure(error))
                } else if let user = user {
                    self.addScopes(scopes: scopes, toUser: user, presentingViewController: presentingViewController)
                    completion(.success(user))
                } else {
                    // TODO: Handle nil user present to suer.
                    completion(.failure(AuthenticationError.nilUser))
                }
            }
        }
        
        // No google user is or has previously signed in. Launch sign in flow
        else {
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
                                                
                completion(.success(result.user))
            }
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
