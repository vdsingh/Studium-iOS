//
//  AuthenticationCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

// TODO: Docstrings
class AuthenticationCoordinator: NSObject, NavigationCoordinator, UINavigationControllerDelegate {
        
    // TODO: Docstrings
    weak var parentCoordinator: Coordinator?
    
    // TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    // TODO: Docstrings
    var navigationController: UINavigationController
    
    // TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // TODO: Docstrings
    required override init() {
        self.navigationController = UINavigationController()
        super.init()
        self.setRootViewController(self.navigationController)
    }
    
    //TODO: Docstrings
    func start() {
        DispatchQueue.main.async {
            self.navigationController.delegate = self
            self.showStartViewController()
        }
    }

    //TODO: Docstrings
    func showStartViewController() {
        DispatchQueue.main.async {
            let startVC = StartViewController.instantiate()
            startVC.coordinator = self
            self.navigationController.pushViewController(startVC, animated: false)
        }
    }
    
    //TODO: Docstrings
    func showLoginViewController(animated: Bool) {
        DispatchQueue.main.async {
            let loginVC = LoginViewController.instantiate()
            loginVC.coordinator = self
            self.navigationController.pushViewController(loginVC, animated: animated)
        }
    }
    
    //TODO: Docstrings
    func showSignUpViewController(animated: Bool) {
        DispatchQueue.main.async {
            let registerVC = RegisterViewController.instantiate()
            registerVC.coordinator = self
            self.navigationController.pushViewController(registerVC, animated: animated)
        }
    }
    
    // TODO: Docstrings
    func showUserSetupFlow() {
        var userSetupCoordinator = UserSetupCoordinator()
        userSetupCoordinator.parentCoordinator = self.parentCoordinator
        self.parentCoordinator?.childCoordinators.append(userSetupCoordinator)
        userSetupCoordinator.start()
        self.finish()
    }
    
    //TODO: Docstrings
    func childDidFinish(_ child: Coordinator?) {
        fatalError("AuthenticationCoordinator should not have any children")
    }
}
