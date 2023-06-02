//
//  Coordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Docstrings
protocol Coordinator: AnyObject, Debuggable {
    
    //TODO: Docstrings
    var parentCoordinator: Coordinator? { get set }
        
    //TODO: Docstrings
    var childCoordinators: [Coordinator] { get set }

    //TODO: Docstrings
    func start()
    
    //TODO: Docstrings
    func finish()
    
    //TODO: Docstrings
    func childDidFinish(_ child: Coordinator?)
    

}

protocol NavigationCoordinator: Coordinator {
    
    //TODO: Docstrings
    var navigationController: UINavigationController { get set }
    
    //TODO: Docstrings
    init(_ navigationController: UINavigationController)
}

//TODO: Docstrings
extension Coordinator {
    
    //TODO: Docstrings
    func finish() {
        self.printDebug("finish called")
        childCoordinators.removeAll()
        
        guard let parentCoordinator = self.parentCoordinator  else {
            return
        }
        
        for (index, coordinator) in parentCoordinator.childCoordinators.enumerated() {
            if coordinator === self {
                parentCoordinator.childCoordinators.remove(at: index)
                break
            }
        }
        
        parentCoordinator.childDidFinish(self)
        self.printDebug("finish call ended")
    }
    
    //TODO: Docstrings
    func setNewRootNavigationController() -> UINavigationController {
        let navController = UINavigationController()
        self.setRootViewController(navController)
        return navController
    }
    
    //TODO: Docstrings
    func setRootViewController(_ viewController: UIViewController) {
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
    }
}

extension Debuggable where Self: Coordinator {
    func printDebug(_ message: String) {
        if self.debug || DebugFlags.coordinators {
            print("$LOG \(String(describing: self)): \(message)")
        }
    }
}
