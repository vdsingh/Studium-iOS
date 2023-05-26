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
protocol Coordinator: AnyObject {
    
    var parentCoordinator: Coordinator? { get set }
        
    //TODO: Docstrings
    var childCoordinators: [Coordinator] { get set }
    
    //TODO: Docstrings
    var navigationController: UINavigationController { get set }
    
    //TODO: Docstrings
    func start()
    
    //TODO: Docstrings
    func finish()
    
    init(_ navigationController: UINavigationController)
}

//TODO: Docstrings
extension Coordinator {
    
    //TODO: Docstrings
    func finish() {
        childCoordinators.removeAll()
    }
}

//protocol Storyboarded {
//    static func instantiate() -> Self
//}
//
//extension Storyboarded where Self: UIViewController {
//    static func instantiate() -> Self {
//        let id = String(describing: self)
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        return storyboard.instantiateViewController(withIdentifier: id) as! Self
//    }
//}
