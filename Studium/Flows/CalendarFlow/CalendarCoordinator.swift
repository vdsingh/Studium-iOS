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
        
    //TODO: Docstrings
    weak var parentCoordinator: Coordinator?
    
    //TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    //TODO: Docstrings
    var navigationController: UINavigationController
    
    //TODO: Docstrings
    var tabItemInfo: TabItemConfig = .calendarFlow
    
    //TODO: Docstrings
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // TODO: Docstrings
    required override init() {
        self.navigationController = UINavigationController()
        super.init()
        self.setRootViewController(self.navigationController)
    }
    
    //TODO: Docstrings
    func start() {
        self.showDayScheduleViewController()
    }
    
    //TODO: Docstrings
    func showDayScheduleViewController() {
        let dayScheduleVC = DayScheduleViewController.instantiate()
        dayScheduleVC.coordinator = self
        dayScheduleVC.tabBarItem = UITabBarItem(title: self.tabItemInfo.title, image: self.tabItemInfo.images.unselected, tag: self.tabItemInfo.orderNumber)
        dayScheduleVC.tabBarItem.selectedImage = self.tabItemInfo.images.selected
        
        
        self.navigationController.pushViewController(dayScheduleVC, animated: false)
    }
    
    //TODO: Docstrings
    func showMonthScheduleViewController() {
        let monthScheduleVC = CalendarViewController.instantiate()
        monthScheduleVC.coordinator = self
        self.navigationController.pushViewController(monthScheduleVC, animated: true)
    }
    
    //TODO: Docstrings
    func showSettingsFlow() {
        let settingsCoordinator = SettingsCoordinator(self.navigationController)
        self.childCoordinators.append(settingsCoordinator)
        settingsCoordinator.parentCoordinator = self
        settingsCoordinator.start()
    }
    
    //TODO: Docstrings
    func childDidFinish(_ child: Coordinator?) {
        
    }
}
