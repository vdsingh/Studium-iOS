//
//  HabitsCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class HabitsCoordinator: NSObject, TabItemCoordinator {
    
    var debug = false
    
    weak var parentCoordinator: Coordinator?
    
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    var tabItemInfo: TabItemInfo = .habitsFlow
    
    //TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start(replaceRoot: Bool = false) {
        self.showHabitsListFlow()
    }
    
    func showHabitsListFlow() {
        let habitsVC = HabitsViewController.instantiate()
        habitsVC.coordinator = self
        habitsVC.tabBarItem = UITabBarItem(title: self.tabItemInfo.title, image: self.tabItemInfo.images.unselected, tag: self.tabItemInfo.orderNumber)
        habitsVC.tabBarItem.selectedImage = self.tabItemInfo.images.selected
        self.navigationController.pushViewController(habitsVC, animated: false)
    }
    
    func childDidFinish(_ child: Coordinator?) {
        
    }
}
