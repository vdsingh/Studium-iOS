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
    
    weak var coordinator: AuthenticationCoordinator?
    
    let spinner: UIActivityIndicatorView = {
       let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.backgroundColor = .black
        spinner.layer.cornerRadius = 10
        spinner.style = .large
        return spinner
    }()
    
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

    
    override func viewDidLoad() {
        self.view.addSubview(self.spinner)
        
        NSLayoutConstraint.activate([
            self.spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.spinner.heightAnchor.constraint(equalToConstant: 80),
            self.spinner.widthAnchor.constraint(equalToConstant: 80),
        ])
        
//        self.spinner.startAnimating()

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
        self.spinner.startAnimating()

        AuthenticationService.shared.handleLoginAsGuest { [weak self] result in
            self?.handleLoginResult(result: result)
        }
    }
    
    // TODO: Docstrings
    @IBAction func fbLoginButtonClicked() {
        self.spinner.startAnimating()

        AuthenticationService.shared.handleLoginWithFacebook(presentingViewController: self) { [weak self] result in
            self?.handleLoginResult(result: result)
        }
    }
    
    // TODO: Docstrings
    @objc func googleLoginClicked() {
        self.spinner.startAnimating()

        AuthenticationService.shared.handleLoginWithGoogle(presentingViewController: self) { [weak self] result in
            self?.handleLoginResult(result: result)
        }
    }
    
    // TODO: Docstrings
    @objc func emailPasswordLoginClicked(email: String, password: String) {
        self.spinner.startAnimating()

        AuthenticationService.shared.handleLoginWithEmailAndPassword(email: email, password: password) { [weak self] result in
            self?.handleLoginResult(result: result)
        }
    }
    
    //TODO: Docstrings
    @objc func emailPasswordRegisterClicked(email: String, password: String) {
        self.spinner.startAnimating()
        AuthenticationService.shared.handleRegisterWithEmailAndPassword(email: email, password: password) { [weak self] result in
            self?.handleLoginResult(result: result)
        }
    }
    
    // TODO: Docstrings
    func handleLoginResult(result: Result<User, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(_):
                self.printDebug("Handling general login success")
                self.performSegue(withIdentifier: "toWakeUp", sender: self.sender)
            case .failure(let error):
                print("$ERR (AuthViewController): \(String(describing: error))")
                self.showPopUp(title: "Couldn't Register:", message: error.localizedDescription, actions: [
                    UIAlertAction(title: "Ok", style: .default)
                ])
            }

            self.spinner.stopAnimating()
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
