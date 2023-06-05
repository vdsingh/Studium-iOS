////
////  AddCourseCoordinator.swift
////  Studium
////
////  Created by Vikram Singh on 6/4/23.
////  Copyright © 2023 Vikram Singh. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class AddCourseCoordinator: NavigationCoordinator {
//    var navigationController: UINavigationController
//    
//    var parentCoordinator: Coordinator?
//    
//    var childCoordinators = [Coordinator]()
//    
//    required init(_ navigationController: UINavigationController) {
//        self.navigationController = navigationController
//    }
//    
//    func start(replaceRoot: Bool = false) {
//        self.showAddCourseViewController(refreshDelegate: nil)
//    }
//    
//    func showAddCourseViewController(refreshDelegate: CourseRefreshProtocol?) {
//        let addCourseVC = AddCourseViewController.instantiate()
//        let navController = UINavigationController(rootViewController: addCourseVC)
//        addCourseVC.delegate = refreshDelegate
////        addCourseVC.coordinator = self
//        self.navigationController.topViewController?.present(navController, animated: true)
//    }
//    
//    func childDidFinish(_ child: Coordinator?) {
//        
//    }
//    
//    var debug: Bool
//    
//    
//}
