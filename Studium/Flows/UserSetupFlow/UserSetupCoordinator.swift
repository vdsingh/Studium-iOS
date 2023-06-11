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
class UserSetupCoordinator: NSObject, NavigationCoordinator {
    
    var debug = false
    
    // TODO: Docstrings
    var parentCoordinator: Coordinator?
    
    // TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    // TODO: Docstrings
    var navigationController: UINavigationController
    
    // TODO: Docstrings
    var presentingViewController: UIViewController?
    
    // TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    init (_ presentingViewController: UIViewController) {
        self.navigationController = UINavigationController()
        self.presentingViewController = presentingViewController
    }
    
    // TODO: Docstrings
    required override init() {
        self.navigationController = UINavigationController()
        super.init()
        self.setRootViewController(self.navigationController)
    }
    
    // TODO: Docstrings
    func start() {
        self.showWakeUpIntroViewController()
    }
    
    // TODO: Docstrings
    func showWakeUpIntroViewController() {
        //        DispatchQueue.main.async {
        let startVC = WakeUpIntroController.instantiate()
        startVC.coordinator = self
//        startVC.modalPresentationStyle = .formSheet
        if let presentingViewController = self.presentingViewController {
            startVC.modalPresentationStyle = .popover
            presentingViewController.present(startVC, animated: true)
        } else {
//            if replaceRoot {
//                let newNavigationController = UINavigationController()
//                self.navigationController = newNavigationController
//                newNavigationController.pushViewController(startVC, animated: false)
//                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(newNavigationController)
//            } else {
//                self.navigationController.pushViewController(startVC, animated: true)
//            }
            self.navigationController.pushViewController(startVC, animated: true)
        }
    }
    
    func showTabBarFlow() {
        let tabBarCoordinator = TabBarCoordinator()
        tabBarCoordinator.parentCoordinator = self.parentCoordinator
        self.parentCoordinator?.childCoordinators.append(tabBarCoordinator)
        tabBarCoordinator.start(replaceRoot: (true, animated: true))
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
