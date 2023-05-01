//
//  FBAndGoogleAuthViewController.swift
//  Studium
//
//  Created by Vikram Singh on 3/31/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit
import GoogleSignIn
import RealmSwift

// TODO: Docstrings
class AuthViewController: UIViewController {
    
    let debug = false
    var codeLocationString: String = "FBAndGoogleAuthViewController"
    
    // TODO: Docstrings
    var sender: Any? = AuthViewController.self

    // TODO: Docstrings
    @IBAction func handleLoginAsGuest(){
        let app = App(id: Secret.appID)
        let client = app.emailPasswordAuth
        let email = UIDevice.current.identifierForVendor?.uuidString
        let password = "password"
        client.registerUser(email: email!, password: password) { [weak self] (error) in
            if let error = error {
                print("$ERR (AuthViewController): \(error.localizedDescription)")
            }
            
            self?.printDebug("successfully registered guest.")
        }
        
        app.login(credentials: Credentials.emailPassword(email: email!, password: password)) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print("$ERR (AuthViewController): login failed: \(error.localizedDescription)")
            case .success(let user):
                self?.printDebug("successfully logged in as user \(user)")
                UserDefaults.standard.setValue(email, forKey: "email")
                self?.handleGeneralLoginSuccess()
//                DispatchQueue.main.async {
//                    self.performSegue(withIdentifier: "toWakeUp", sender: self)
//                }
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
    
    //FACEBOOK
    
    // Once the button is clicked, show the login dialog
    @IBAction func fbLoginButtonClicked() {
        let loginManager = LoginManager()
        
        if AccessToken.current != nil {
            loginManager.logOut()
            return
        }
        
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { [weak self] result, error in
            if let error = error {
                print("ERR: encountered Error when logging in with Facebook: \(error)")
            } else if let result = result, result.isCancelled {
                print("LOG: User Cancelled Login with Facebook")
            } else {
                self?.printDebug("User Successfully Logged In with Facebook")
                self?.handleFBLoginSuccess()
            }
        }
    }
    
    
    func handleFBLoginSuccess(){
        if let accessToken = AccessToken.current, !accessToken.isExpired {
                // User is logged in, do work such as go to next view controller.
            let credentials = Credentials.facebook(accessToken: accessToken.tokenString)
//            K.app.login(credentials: credentials) { result in
//                DispatchQueue.main.async {
//                    switch result {
//                    case .failure(let error):
//                        print("Failed to log in to MongoDB Realm: \(error)")
//                    case .success(let user):
////                        accessToke
//                        print("Successfully logged in to MongoDB Realm using Facebook OAuth. \(user)")
//                        // Now logged in, do something with user
//                        // Remember to dispatch to main if you are doing anything on the UI thread
////                        let email =
//                        self.handleGeneralLoginSuccess(email: nil)
//                    }
//                }
//            }
        }else{
            print("$ERR: something is wrong with AccessToken when trying to log in with Facebook on StartViewController.")
        }
    }
    
    //this function just does what all authentication methods do upon success (Google, Facebook, Email, etc.)
    @objc func handleGeneralLoginSuccess(){
//        let defaults = UserDefaults.standard
//
//        if email != nil{
//            defaults.setValue(email, forKey: "email")
//
//        } else  {
//            defaults.setValue("Logged In", forKey: "email")
//        }
        printDebug("Handling general login success")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toWakeUp", sender: self.sender)
        }
    }
    
    @objc func googleSignInClicked() {
        GoogleAuthenticationService.shared.handleSignIn(
            rootViewController: self,
            completion: { [weak self] result in
                switch result {
                case .success(_):
                    self?.printDebug("Successfully signed in with google")
                    self?.perform(#selector(self?.handleGeneralLoginSuccess), with: nil, afterDelay: 1)
                case .failure(let error):
                    //TODO: handle errors
                    print("$ERR (StartViewController): \(String(describing: error))")
                }
            }
        )
    }
}

extension AuthViewController: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (\(String(describing: self))): \(message)")
        }
    }

}
