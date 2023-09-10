//
//  MainCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Docstrings
class AppCoordinator: NSObject, Coordinator {
    
    var debug = false
    
    //TODO: Docstrings
    weak var parentCoordinator: Coordinator? = nil
    
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
    var authenticationService: AuthenticationService
    
    //TODO: Docstrings
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    //TODO: Docstrings
    func start() {
        if self.authenticationService.userIsLoggedIn {
            self.showMainFlow()
        } else {
            self.showAuthenticationFlow()
        }
    }
    
    //TODO: Docstrings
    func showAuthenticationFlow() {
        Log.d("showAuthenticationFlow called")
        let child = AuthenticationCoordinator()
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    //TODO: Docstrings
    func showMainFlow() {
        Log.d("showMainFlow called")
        let child = TabBarCoordinator()
        self.setRootViewController(child.tabBarController)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start(replaceRoot: (true, animated: true))
    }
    
    //TODO: Docstrings
    func showUserSetupFlow() {
        Log.d("showUserSetupFlow called")
        let child = UserSetupCoordinator()
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    //TODO: Docstrings
    func childDidFinish(_ child: Coordinator?) {
//        if child is AuthenticationCoordinator {
//            self.showUserSetupFlow()
//        } else if child is UserSetupCoordinator {
//            self.showMainFlow()
//        }
    }
    
//    private func removeAllControllersExceptLast() {
//        let viewControllers = self.navigationController.viewControllers
//        self.navigationController.viewControllers.remove(atOffsets: IndexSet(integersIn: 0...viewControllers.count))
//
//        let newVCs = [self.navigationController.viewControllers.last!]
//
//        self.navigationController.setViewControllers(newVCs, animated: true)
//    }
    
//    private func removeAllControllersExceptLast() {
//        var newVCs = [UIViewController]()
//
//        if let lastVC = self.navigationController.viewControllers.last {
//            newVCs.append(lastVC)
//        }
//
//        self.navigationController.setViewControllers(newVCs, animated: true)
//    }
}
