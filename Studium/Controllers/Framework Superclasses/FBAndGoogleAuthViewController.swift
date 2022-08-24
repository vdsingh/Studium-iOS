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
class FBAndGoogleAuthViewController: UIViewController, GIDSignInDelegate {
    var codeLocationString: String = "FBAndGoogleAuthViewController"
    
    var sender: Any? = FBAndGoogleAuthViewController.self

    @IBAction func handleLoginAsGuest(){
        let app = App(id: Secret.appID)
        let client = app.emailPasswordAuth
        let email = UIDevice.current.identifierForVendor?.uuidString
        let password = "password"
        client.registerUser(email: email!, password: password) { (error) in
            guard error == nil else {
                print("ERROR: failed to register guest: \(error!.localizedDescription)")
                return
            }
            print("LOG: successfully registered guest.")
        }
        
        app.login(credentials: Credentials.emailPassword(email: email!, password: password)) { (result) in
            switch result {
            case .failure(let error):
                print("ERROR: login failed: \(error.localizedDescription)")
            case .success(let user):
                print("Log: successfully logged in as user \(user)")
                let defaults = UserDefaults.standard
                defaults.setValue(email, forKey: "email")
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "toWakeUp", sender: self)
                }
            }
        }
    }
    
    //GOOGLE
    func sign(_ signIn: GIDSignIn!, didSignInFor googleUser: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        // Signed in successfully, forward credentials to MongoDB Realm.
        let credentials = Credentials.google(serverAuthCode: googleUser.serverAuthCode)
        K.app.login(credentials: credentials) { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print("Failed to log in to MongoDB Realm: \(error)")
                case .success(let user):
//                    Logs.Authentication.googleLoginSuccess(logLocation: self.codeLocationString, additionalInfo: "User: \(user)").printLog()
                    self.handleGeneralLoginSuccess(email: googleUser.profile.email)
                }
            }
        }
    }
    
    //FACEBOOK
    
    // Once the button is clicked, show the login dialog
    @IBAction func fbLoginButtonClicked() {
        let loginManager = LoginManager()
        
        if AccessToken.current != nil {
            loginManager.logOut()
            return
        }
        
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { result, error in
            if let error = error {
                print("ERROR: encountered Error when logging in with Facebook: \(error)")
            } else if let result = result, result.isCancelled {
                print("LOG: User Cancelled Login with Facebook")
            } else {
                print("LOG: User Successfully Logged In with Facebook")
                self.handleFBLoginSuccess()
            }
        }
    }
    
    
    func handleFBLoginSuccess(){
        if let accessToken = AccessToken.current, !accessToken.isExpired {
                // User is logged in, do work such as go to next view controller.
            let credentials = Credentials.facebook(accessToken: accessToken.tokenString)
            K.app.login(credentials: credentials) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .failure(let error):
                        print("Failed to log in to MongoDB Realm: \(error)")
                    case .success(let user):
//                        accessToke
                        print("Successfully logged in to MongoDB Realm using Facebook OAuth. \(user)")
                        // Now logged in, do something with user
                        // Remember to dispatch to main if you are doing anything on the UI thread
//                        let email =
                        self.handleGeneralLoginSuccess(email: nil)
                    }
                }
            }
        }else{
            print("ERROR: something is wrong with AccessToken when trying to log in with Facebook on StartViewController.")
        }
    }
    
    //this function just does what all authentication methods do upon success (Google, Facebook, Email, etc.)
    func handleGeneralLoginSuccess(email: String?){
        let defaults = UserDefaults.standard

        if email != nil{
            defaults.setValue(email, forKey: "email")

        } else  {
            defaults.setValue("Logged In", forKey: "email")
        }
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toWakeUp", sender: self.sender)
        }
    }
}
