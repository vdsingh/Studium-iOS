//
//  CoursesCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class CoursesCoordinator: NSObject, TabItemCoordinator {
    
    var debug = false
    
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    var tabItemInfo: TabItemInfo = .coursesFlow
    
    //TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(replaceRoot: Bool) {
        let rootVC = CoursesViewController.instantiate()
        rootVC.coordinator = self
        self.navigationController.tabBarItem = UITabBarItem(title: self.tabItemInfo.title, image: self.tabItemInfo.images.unselected, tag: self.tabItemInfo.orderNumber)
        self.navigationController.tabBarItem.selectedImage = self.tabItemInfo.images.selected
        self.navigationController.pushViewController(rootVC, animated: false)
    }
    
    func showCoursesListFlow() {
        
    }
    
    func childDidFinish(_ child: Coordinator?) {
        
    }
}
