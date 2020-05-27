//
//  RegisterViewController.swift
//  Studium
//
//  Created by Vikram Singh on 5/25/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import Foundation
import Firebase

class RegisterViewController: UIViewController{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error == nil{
                    self.performSegue(withIdentifier: "toWakeUp", sender: self)
                }else{
                    self.errorLabel.text = error?.localizedDescription
                    print("error label text updated. error: \(error?.localizedDescription)")
                }
            }
        }else{
            print("error with email and password.")
        }
    }
    @IBAction func loginPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "toLogin", sender: self)

    }
    @IBAction func continueAsGuestPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toMain", sender: self)

    }
}
