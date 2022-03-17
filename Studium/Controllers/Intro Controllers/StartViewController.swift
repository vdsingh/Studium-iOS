//
//  StartViewController.swift
//  Studium
//
//  Created by Vikram Singh on 6/5/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import RealmSwift
class StartViewController: UIViewController, GIDSignInDelegate{
    
    let app = App(id: Secret.appID)

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        signUpButton.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
        
        googleSignInButton.style = GIDSignInButtonStyle.wide
        googleSignInButton.colorScheme = GIDSignInButtonColorScheme.dark
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        navigationItem.hidesBackButton = false
    }

    

    func sign(_ signIn: GIDSignIn!, didSignInFor googleUser: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
//            GIDSignInError.has
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
                    print("Successfully logged in to MongoDB Realm using Google OAuth.")
                    let defaults = UserDefaults.standard
                    defaults.setValue(googleUser.profile.email, forKey: "email")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toWakeUp", sender: self)
                    }
                }
            }
        }
    }
}
