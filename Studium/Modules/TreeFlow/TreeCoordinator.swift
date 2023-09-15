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
    var debug = false

    var tabItemInfo: TabItemConfig = .treeFlow
    
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
        self.navigationController.tabBarItem = UITabBarItem(title: self.tabItemInfo.title, image: self.tabItemInfo.images.unselected, tag: self.tabItemInfo.orderNumber)
        self.navigationController.tabBarItem.selectedImage = self.tabItemInfo.images.selected
        let treeVC = TreeViewController()
        self.navigationController.pushViewController(treeVC, animated: true)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        
    }
}
