//
//  CalendarCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Docstrings
class CalendarCoordinator: NSObject, TabItemCoordinator {
    
    var debug = false
    
    //TODO: Docstrings
    weak var parentCoordinator: Coordinator?
    
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
    var navigationController: UINavigationController
    
    //TODO: Docstrings
    var tabItemInfo: TabItemInfo = .calendarFlow
    
    //TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let rootVC = DayScheduleViewController.instantiate()
        rootVC.coordinator = self
        rootVC.tabBarItem = UITabBarItem(title: self.tabItemInfo.title, image: self.tabItemInfo.image, tag: self.tabItemInfo.orderNumber)
        self.navigationController.pushViewController(rootVC, animated: false)
    }
    
    func showDayScheduleFlow() {
        
    }
    
    func childDidFinish(_ child: Coordinator?) {
        
    }
}
