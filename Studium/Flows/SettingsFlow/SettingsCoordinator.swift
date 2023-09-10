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
class SettingsCoordinator: NSObject, NavigationCoordinator, AlertTimesSelectionShowingCoordinator {
    
    //TODO: Docstrings
//    var debug: Bool = false

    //TODO: Docstrings
    var parentCoordinator: Coordinator?
    
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
    var navigationController: UINavigationController
    
    var formNavigationController: UINavigationController?
    
//    var formNavigationController: UINavigationController? {
//        return self.navigationController
//    }
    
    // TODO: Docstrings
    var rootViewController: UIViewController?
    
    //TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.formNavigationController = navigationController
    }
    
    // TODO: Docstrings
    required override init() {
        self.navigationController = UINavigationController()
        super.init()
        self.setRootViewController(self.navigationController)
    }
    
    //TODO: Docstrings
    func start() {
        let startViewController = self.showSettingsListViewController()
        self.rootViewController = startViewController
    }
    
    // TODO: Docstrings
    func showSettingsListViewController() -> UIViewController {
//        let settingsListVC = SettingsViewController.instantiate()
        let settingsVC = SettingsViewController(coordinator: self, databaseService: DatabaseService.shared)
//        settingsVC.coordinator = self
        self.navigationController.pushViewController(settingsVC, animated: true)
        return settingsVC
    }
    
    // TODO: Docstrings
    func showAuthenticationFlow() {
        DispatchQueue.main.async {
            let authenticationCoordinator = AuthenticationCoordinator()
            authenticationCoordinator.parentCoordinator = self.parentCoordinator
            self.parentCoordinator?.childCoordinators.append(authenticationCoordinator)
            authenticationCoordinator.start()
        }
    }
    
    // TODO: Docstrings
    func showUserSetupFlow() {
        var userSetupCoordinator = UserSetupCoordinator(self.navigationController)
        
        if let rootViewController = self.rootViewController {
            userSetupCoordinator = UserSetupCoordinator(rootViewController)
        }
        
        userSetupCoordinator.parentCoordinator = self
        self.parentCoordinator?.childCoordinators.append(userSetupCoordinator)
        userSetupCoordinator.start()
    }
    
    //TODO: Docstrings
    func childDidFinish(_ child: Coordinator?) {
        if let child = child as? UserSetupCoordinator {
//            self.showSettingsListViewController()
//            self.setRootViewController(self.navigationController)
            
            if let rootViewController = self.rootViewController {
                rootViewController.dismiss(animated: true)
//                self.navigationController.popToViewController(rootViewController, animated: true)
                
            }
        }
    }
}
