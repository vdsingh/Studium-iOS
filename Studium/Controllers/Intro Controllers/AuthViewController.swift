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
    
    func showPopUp(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for action in actions {
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - Handle Authentication Methods
extension AuthViewController {
    
    // TODO: Docstrings
    @IBAction func guestLoginClicked(){
        AuthenticationService.shared.handleLoginAsGuest { [weak self] result in
            switch result {
            case .success(let user):
                self?.handleLoginSuccess()
            case .failure(let error):
                print("$ERR (AuthViewController): \(String(describing: error))")
            }
        }
    }
    
    // TODO: Docstrings
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
    
    // TODO: Docstrings
    @objc func googleLoginClicked() {
        AuthenticationService.shared.handleLoginWithGoogle(presentingViewController: self) { [weak self] result in
            switch result {
            case .success(let user):
                self?.handleLoginSuccess()
            case .failure(let error):
                print("$ERR (AuthViewController): \(String(describing: error))")
            }
        }
    }
    
    // TODO: Docstrings
    @objc func emailPasswordLoginClicked(email: String, password: String) {
        AuthenticationService.shared.handleLoginWithEmailAndPassword(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                self?.handleLoginSuccess()
            case .failure(let error):
                print("$ERR (AuthViewController): \(String(describing: error))")
                self?.showPopUp(title: "Couldn't Login:", message: error.localizedDescription, actions: [
                    UIAlertAction(title: "Ok", style: .default)
                ])
            }
        }
    }
    
    //TODO: Docstrings
    @objc func emailPasswordRegisterClicked(email: String, password: String) {
        AuthenticationService.shared.handleRegisterWithEmailAndPassword(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                // Once we have successfully registered, attempt to log in
                self?.emailPasswordLoginClicked(email: email, password: password)
            case .failure(let error):
                print("$ERR (AuthViewController): \(String(describing: error))")
                self?.showPopUp(title: "Couldn't Register:", message: error.localizedDescription, actions: [
                    UIAlertAction(title: "Ok", style: .default)
                ])
            }
        }
    }
    
    // TODO: Docstrings
    @objc func handleLoginSuccess(){
        printDebug("Handling general login success")
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "toWakeUp", sender: self.sender)
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
