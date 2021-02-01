//
//  LoginViewController.swift
//  Studium
//
//  Created by Vikram Singh on 1/31/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] authResult, error in
          guard let strongSelf = self else { return }
            if error == nil{
                strongSelf.performSegue(withIdentifier: "toWakeUp", sender: self)
            }else{
                print("Email: \(strongSelf.emailTextField.text!)")
                print("Password: \(strongSelf.passwordTextField.text!)")
                print(error!)
            }
          // ...
        }
    }
    
    @IBAction func noAccountButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toRegister", sender: self)
    }
}
