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

import FBSDKLoginKit
import FBSDKCoreKit

// TODO: Docstrings
class StartViewController: AuthenticationViewController {
    
    // TODO: Docstrings
    @IBOutlet weak var signUpButton: UIButton!
    
    // TODO: Docstrings
    @IBOutlet weak var loginButton: UIButton!
    
    // TODO: Docstrings
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    // TODO: Docstrings
    @IBOutlet weak var facebookSignInButton: FBLoginButton!
    
    // TODO: Docstrings
    @IBOutlet weak var guestSignInButton: UIButton!
    
    // TODO: Docstrings
    @IBOutlet weak var mainStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.signUpButton.layer.cornerRadius = 10
        self.loginButton.layer.cornerRadius = 10
        self.facebookSignInButton.layer.cornerRadius = 10
        
        self.googleSignInButton.style = GIDSignInButtonStyle.wide
        self.googleSignInButton.colorScheme = GIDSignInButtonColorScheme.dark

        navigationItem.hidesBackButton = false
        
        self.setSelectors()
    }
    
    // TODO: Docstrings
    private func setSelectors() {
        print("SETTING SELECTORS. COORDINATOR: \(self.coordinator)")
        self.loginButton.addTarget(self, action: #selector(self.loginButtonClicked), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(self.signUpButtonClicked), for: .touchUpInside)
        self.googleSignInButton.addTarget(self, action: #selector(googleLoginClicked), for: .touchUpInside)
        self.facebookSignInButton.addTarget(self, action: #selector(fbLoginButtonClicked), for: .touchUpInside)
        self.guestSignInButton.addTarget(self, action: #selector(guestLoginClicked), for: .touchUpInside)
    }
}
