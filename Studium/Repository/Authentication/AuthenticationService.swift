//
//  AuthenticationService.swift
//  Studium
//
//  Created by Vikram Singh on 2/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import GoogleSignIn
import FBSDKLoginKit
import RealmSwift

enum AuthenticationError: Error {
    case cancelled
    case nilResult
    case nilAuthCode
    case nilUser
    case nildeviceID
    case nilAccessToken
}


//TODO: Implement
//TODO: Docstrings
class AuthenticationService {
    
    let debug = true
    
    //TODO: Docstrings
    static let shared = AuthenticationService()
    
    private lazy var app: App = {
        return App(id: Secret.appID)
    }()
    
    var userIsLoggedIn: Bool {
        if let currentUser = self.app.currentUser, currentUser.isLoggedIn {
            return true
        }
        
        return false
    }

    private init() {}
    
    private func handleLogin(credentials: Credentials, completion: @escaping (Result<User, Error>) -> Void) {
        self.app.login(credentials: credentials, completion)
    }
    
    func handleLogOut(completion: @escaping (Error?) -> Void) {
        guard let currentUser = self.app.currentUser else {
            print("$ERR (AuthenticationService): tried to log out but current user is nil.")
            completion(AuthenticationError.nilUser)
            return
        }
        
        currentUser.logOut(completion: { error in
            if let error = error {
                print("$ERR (AuthenticationService): error logging out: \(String(describing: error))")
                completion(error)
            }
            
            completion(nil)
        })
    }
    
    //TODO: Docstrings
    func attemptRestorePreviousSignIn(completion: @escaping (Result<User, Error>) -> Void) {
        self.attemptRestorePreviousGoogleLogin { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                print("ERROR: \(String(describing: error))")
                //                completion(.failure(<#T##Error#>))
            }
        }
    }
}

// MARK: - Facebook Authentication

extension AuthenticationService {
    
    // TODO: Docstrings
    func handleLoginWithFacebook(presentingViewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        
        let loginManager = LoginManager()
        
        if AccessToken.current != nil {
            loginManager.logOut()
            return
        }
            
        loginManager.logIn(
            viewController: presentingViewController,
            configuration: LoginConfiguration(permissions: ["email"], tracking: .enabled))
        { [weak self] loginResult in
            switch loginResult {
            case .success(_, _, let accessToken):
                if let accessToken = accessToken {
                    let credentials = Credentials.facebook(accessToken: accessToken.tokenString)
                    self?.handleLogin(credentials: credentials, completion: completion)
                } else {
                    completion(.failure(AuthenticationError.nilAccessToken))
                }
                
            case .cancelled:
                completion(.failure(AuthenticationError.cancelled))
            case .failed(let error):
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Google Authentication

extension AuthenticationService {
    
    // TODO: Docstrings
    func handleLoginWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController
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

// MARK: - Guest Login

extension AuthenticationService {
    func handleLoginAsGuest(completion: @escaping (Result<User, Error>) -> Void) {
        let client = app.emailPasswordAuth
        guard let email = UIDevice.current.identifierForVendor?.uuidString else {
            completion(.failure(AuthenticationError.nildeviceID))
            return
        }
        
        let password = "password"
        client.registerUser(email: email, password: password) { [weak self] (error) in
            if let error = error {
                print("$ERR (AuthViewController): \(error.localizedDescription)")
            }
            
            self?.printDebug("successfully registered guest.")
        }
        
        self.app.login(credentials: Credentials.emailPassword(email: email, password: password)) { [weak self] result in
            switch result {
            case .failure(let error):
                print("$ERR (AuthenticationService): login failed: \(error.localizedDescription)")
            case .success(let user):
                self?.printDebug("successfully logged in as user \(user)")
                completion(.success(user))
            }
        }
    }
}

extension AuthenticationService: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (AuthenticationService): \(message)")
        }
    }
}
