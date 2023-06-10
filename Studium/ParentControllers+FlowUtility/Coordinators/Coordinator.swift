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
    func start(replaceRoot: Bool)
    
    //TODO: Docstrings
    func finish()
    
    //TODO: Docstrings
    func childDidFinish(_ child: Coordinator?)
    
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
//    func setNewRootNavigationController() {
//        DispatchQueue.main.async {
//            let navController = UINavigationController()
//            self.setRootViewController(navController)
//        }
//    }
    
    //TODO: Docstrings
    func setRootViewController(_ viewController: UIViewController) {
        DispatchQueue.main.async {
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(viewController)
        }
    }
}

extension Debuggable where Self: Coordinator {
    func printDebug(_ message: String) {
        if self.debug || DebugFlags.coordinators {
            print("$LOG \(String(describing: self)): \(message)")
        }
    }
}
