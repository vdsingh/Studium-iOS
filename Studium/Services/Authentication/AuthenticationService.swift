//
//  AuthenticationService.swift
//  Studium
//
//  Created by Vikram Singh on 2/2/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift

//TODO: Docstrings
enum AuthenticationError: Error {
    case cancelled
    case nilResult
    case nilAuthCode
    case nilUser
    case nildeviceID
    case nilAccessToken
    case registeredSuccessfullyButUserWasNil
}


//TODO: Docstrings
class AuthenticationService: NSObject, Debuggable {
    
    let debug = true
    
    //TODO: Docstrings
    static let shared = AuthenticationService()
    
    //TODO: Docstrings
    lazy var app: App = {
        guard let appID = Bundle.main.object(forInfoDictionaryKey: "MongoDBAppID") as? String,
              !appID.isEmpty else {
            fatalError("MongoDB App ID value does not exist or is empty.")
        }
        
        return App(id: appID)
    }()
    
    //TODO: Docstrings
    var userIsLoggedIn: Bool {
        if let currentUser = self.app.currentUser, currentUser.isLoggedIn {
            return true
        }
        
        return false
    }
    
    //TODO: Docstrings
    var userID: String? {
        if let currentUser = self.app.currentUser {
            return currentUser.id
        }
        
        return nil
    }
    
    //TODO: Docstrings
    var user: User? {
        return self.app.currentUser
    }
    
    var userEmail: String? {
        return self.user?.profile.email
    }
    
    var googleAccessTokenString: String? {
        get { return UserDefaultsService.shared.getGoogleAccessTokenString() }
        set { UserDefaultsService.shared.setGoogleAccessTokenString(newValue) }
    }
    
    //TODO: Docstrings
    func handleLogin(credentials: Credentials, completion: @escaping (Result<User, Error>) -> Void) {
        if self.userIsLoggedIn {
            self.handleLogOut { error in
                if let error = error {
                    print("$ERR (AuthenticationService): \(String(describing: error))")
                }
            }
        }
        
        self.app.login(credentials: credentials, { result in
            switch result {
            case .success(let user):
                Log.g("successfully logged into app as user \(user)")
            case .failure(let error):
                Log.e(error, additionalDetails: "attempted to login to app with credentials \(credentials) but failed.")
            }
            
            CrashlyticsService.shared.setUserID()
            completion(result)
        })
    }
    
    //TODO: Docstrings
    func handleLogOut(completion: @escaping (Error?) -> Void) {
        guard let currentUser = self.app.currentUser else {
            Log.e(AuthenticationError.nilUser, additionalDetails: "tried to log out but current user is nil.")
            completion(AuthenticationError.nilUser)
            return
        }
        
        currentUser.logOut(completion: { error in
            if let error = error {
                Log.e(error, additionalDetails: "error logging out: \(String(describing: error))")
                completion(error)
                return
            }
            
            CrashlyticsService.shared.setUserID()
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
                Log.v(error)
            }
        }
    }
}

// MARK: - Email/Password Login

extension AuthenticationService {
    
    //TODO: Docstrings
    func handleLoginWithEmailAndPassword(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let credentials = Credentials.emailPassword(email: email, password: password)
        self.handleLogin(credentials: credentials, completion: completion)
    }
    
    //TODO: Docstrings
    func handleRegisterWithEmailAndPassword(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        let client = self.app.emailPasswordAuth
        client.registerUser(email: email, password: password) { (error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = self.user else {
//                Log.s(AuthenticationError.registeredSuccessfullyButUserWasNil, additionalDetails: "Registered without error, but user is nil", displayToUser: false)
                completion(.failure(AuthenticationError.nilUser))
                return
            }
            
            completion(.success(user))
        }
    }
}

// MARK: - Guest Login

extension AuthenticationService {
    
    //TODO: Docstrings
    func handleLoginAsGuest(completion: @escaping (Result<User, Error>) -> Void) {
        let client = app.emailPasswordAuth
        guard let email = UIDevice.current.identifierForVendor?.uuidString else {
            completion(.failure(AuthenticationError.nildeviceID))
            return
        }
        
        let password = "password"
        client.registerUser(email: email, password: password) { error in
            if let error = error {
                Log.e(error)
            }
            
            Log.g("successfully registered guest.")
        }
        
        self.app.login(credentials: Credentials.emailPassword(email: email, password: password)) { result in
            switch result {
            case .failure(let error):
                print("$ERR (AuthenticationService): login failed: \(error.localizedDescription)")
            case .success(let user):
                Log.g("successfully logged in as user \(user)")
                completion(.success(user))
            }
        }
    }
}

//extension AuthenticationService: Debuggable {
//    func printDebug(_ message: String) {
//        if self.debug {
//            print("$LOG (AuthenticationService): \(message)")
//        }
//    }
//}
