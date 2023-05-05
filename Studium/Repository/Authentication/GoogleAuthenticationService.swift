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
    
//    func attemptRestorePreviousSignIn(completion: @escaping (SignInStatus) -> Void) {
//
//    }
    
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
