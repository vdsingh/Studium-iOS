//
//  MainCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator? = nil
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.showAuthenticationFlow()
////        let vc = StartViewController.instantiate()
////        vc.coordinator = self
////        self.navigationController.pushViewController(vc, animated: false)
//        self.authenticate()
    }
    
    func showAuthenticationFlow() {
        let child = AuthenticationCoordinator(self.navigationController)
        child.parentCoordinator = self
        self.childCoordinators.append(child)
        child.start()
    }
    
    func showMainFlow() {
        let child = TabBarCoordinator(self.navigationController)
        self.childCoordinators.append(child)
        child.start()
//        let child = TabBarCoordinator()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
}
