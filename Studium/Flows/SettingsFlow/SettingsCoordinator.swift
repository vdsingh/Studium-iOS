//
//  SettingsCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Docstrings
class SettingsCoordinator: NavigationCoordinator {
    
    //TODO: Docstrings
    var debug: Bool = false

    //TODO: Docstrings
    var parentCoordinator: Coordinator?
    
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
    var navigationController: UINavigationController
    
    //TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //TODO: Docstrings
    func start() {
        self.showSettingsListViewController()
    }
    
    func showSettingsListViewController() {
        let settingsListVC = SettingsViewController.instantiate()
        settingsListVC.coordinator = self
        self.navigationController.pushViewController(settingsListVC, animated: true)
    }
    
    func showAuthenticationFlow() {
        let authenticationCoordinator = AuthenticationCoordinator(self.setNewRootNavigationController())
        authenticationCoordinator.parentCoordinator = self.parentCoordinator
        self.parentCoordinator?.childCoordinators.append(authenticationCoordinator)
        authenticationCoordinator.start()
    }
    
    //TODO: Docstrings
    func childDidFinish(_ child: Coordinator?) {
        
    }
}
