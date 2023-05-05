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
    
    let debug = true
    var codeLocationString: String = "FBAndGoogleAuthViewController"
    
    // TODO: Docstrings
    var sender: Any? = AuthViewController.self
    
    override func viewWillAppear(_ animated: Bool) {
        AuthenticationService.shared.attemptRestorePreviousSignIn { result in
            switch result {
            case .success(let success):
                print("SUCCESS")
            case .failure(let failure):
                print("FAILED")
            }
        }
    }
    
    // TODO: Docstrings
    @IBAction func handleLoginAsGuest(){
        AuthenticationService.shared.handleLoginAsGuest { [weak self] result in
            switch result {
            case .success(let user):
                self?.handleLoginSuccess()
            case .failure(let error):
                print("$ERR (AuthViewController): \(String(describing: error))")
            }
        }
    }

    //FACEBOOK
    
    // Once the button is clicked, show the login dialog
    @IBAction func fbLoginButtonClicked() {
        AuthenticationService.shared.handleLoginWithFacebook(presentingViewController: self) { [weak self] result in
            switch result {
            case .success(let user):
                self?.handleLoginSuccess()
            case .failure(let error):
                print("$ERR (AuthViewController): \(String(describing: error))")
            }
        }
    }
    
    //this function just does what all authentication methods do upon success (Google, Facebook, Email, etc.)
    @objc func handleLoginSuccess(){
        printDebug("Handling general login success")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toWakeUp", sender: self.sender)
        }
    }
    
    @objc func googleSignInClicked() {
        AuthenticationService.shared.handleLoginWithGoogle(presentingViewController: self) { [weak self] result in
            switch result {
            case .success(let user):
                self?.handleLoginSuccess()
            case .failure(let error):
                print("$ERR (AuthViewController): \(String(describing: error))")
            }
        }
    }
}

extension AuthViewController: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (\(String(describing: self))): \(message)")
        }
    }
}
