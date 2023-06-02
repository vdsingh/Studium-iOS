//
//  UserSetupCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

// TODO: Docstrings
class UserSetupCoordinator: Coordinator {
    
    var debug = false
    
    // TODO: Docstrings
    var parentCoordinator: Coordinator?
    
    // TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    // TODO: Docstrings
    var navigationController: UINavigationController
    
    // TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // TODO: Docstrings
    func start() {
        self.showWakeUpIntroViewController(replaceRoot: true)
    }
    
    // TODO: Docstrings
    func showWakeUpIntroViewController(replaceRoot: Bool) {
        //        DispatchQueue.main.async {
        let startVC = WakeUpIntroController.instantiate()
        startVC.coordinator = self
        if replaceRoot {
            let newNavigationController = UINavigationController()
            self.navigationController = newNavigationController
            newNavigationController.pushViewController(startVC, animated: false)
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(newNavigationController)
        } else {
            self.navigationController.pushViewController(startVC, animated: true)
        }
        //        }
    }
    
    func childDidFinish(_ child: Coordinator?) {
        fatalError("UserSetupCoordinator should not have children")
    }
    
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
