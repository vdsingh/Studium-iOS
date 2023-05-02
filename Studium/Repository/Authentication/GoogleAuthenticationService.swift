//
//  GoogleAuthenticationService.swift
//  Studium
//
//  Created by Vikram Singh on 4/17/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import GoogleSignIn

enum SignInStatus {
    case signedIn
    case signedOut
}

//TODO: Docstring
class GoogleAuthenticationService {
    static let shared = GoogleAuthenticationService()
    
    private init() {}
    
    enum GoogleAuthenticationServiceError: Error {
        case signInResultWasNil
    }
    
    func attemptRestorePreviousSignIn(completion: @escaping (SignInStatus) -> Void) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                print("$ERR (GoogleAuthenticationService): error trying to restore google sign in: \(String(describing: error))")
                completion(.signedOut)
            } else if user == nil {
                // Show the app's signed-out state.
                completion(.signedOut)
            } else {
                // Show the app's signed-in state.
                completion(.signedIn)
            }
        }
    }
    
    func handleSignIn(rootViewController: UIViewController, completion: @escaping (Result<GIDSignInResult, Error>) -> Void) {
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController
        ) { signInResult, error in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let result = signInResult else {
                // Inspect error
                completion(.failure(GoogleAuthenticationServiceError.signInResultWasNil))
                return
            }
            
            // If sign in succeeded, display the app's main content View.
            DispatchQueue.main.async {
                completion(.success(result))
            }
        }
    }
    
    //GOOGLE
//    func sign(_ signIn: GIDSignIn!, didSignInFor googleUser: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
////            GIDSignInError.Code
//            if (error as NSError).code == GIDSignInError.Code.hasNoAuthInKeychain.rawValue {
//                print("The user has not signed in before or they have since signed out.")
//            } else {
//                print("\(error.localizedDescription)")
//            }
//            return
//        }
        // Signed in successfully, forward credentials to MongoDB Realm.
//        googleUser.
//        let credentials = Credentials.google(serverAuthCode: googleUser.serverAuthCode)
//        K.app.login(credentials: credentials) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .failure(let error):
//                    print("$ERR: Failed to log in to MongoDB Realm: \(error)")
//                case .success(let user):
////                    Logs.Authentication.googleLoginSuccess(logLocation: self.codeLocationString, additionalInfo: "User: \(user)").printLog()
//                    self.handleGeneralLoginSuccess(email: googleUser.profile.email)
//                }
//            }
//        }
//    }
}
