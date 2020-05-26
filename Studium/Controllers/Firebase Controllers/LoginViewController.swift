//
//  LoginViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/25/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import Firebase
import UIKit
class LoginViewController: UIViewController{
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBAction func LoginPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if(error != nil){
                    print(error?.localizedDescription)
                    self.errorLabel.text = error?.localizedDescription
                }else{
                    self.performSegue(withIdentifier: K.toMainSegue, sender: self)
                }
            }
        }
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: K.toRegisterSegue, sender: self)
    }
    @IBAction func continueAsGuestButtonPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: K.toMainSegue, sender: self)
    }
    
}
