//
//  TreeCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 8/13/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class TreeCoordinator: NSObject, TabItemCoordinator {

    var tabItemConfig: TabItemConfig = .treeFlow
    
    var navigationController: UINavigationController
    
    var parentCoordinator: Coordinator?
    
    var childCoordinators: [Coordinator] = []
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // TODO: Docstrings
    required override init() {
        self.navigationController = UINavigationController()
        super.init()
        self.setRootViewController(self.navigationController)
    }
    
    func start() {
        self.navigationController.tabBarItem = UITabBarItem(title: self.tabItemConfig.title, image: self.tabItemConfig.images.unselected, tag: self.tabItemConfig.orderNumber)
        self.navigationController.tabBarItem.selectedImage = self.tabItemConfig.images.selected
        let treeVC = TreeViewController()
        self.navigationController.pushViewController(treeVC, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        
    }
}
