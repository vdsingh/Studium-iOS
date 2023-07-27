//
//  HabitsCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/21/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Docstrings
class HabitsCoordinator: NSObject, TabItemCoordinator, StudiumEventFormCoordinator, LogoSelectionShowingCoordinator, AlertTimesSelectionShowingCoordinator {
    
    // TODO: Docstrings
    var debug = false
    
    // TODO: Docstrings
    weak var parentCoordinator: Coordinator?
    
    // TODO: Docstrings
    var childCoordinators = [Coordinator]()
    
    // TODO: Docstrings
    var navigationController: UINavigationController
    
    // TODO: Docstrings
    var formNavigationController: UINavigationController?
    
    // TODO: Docstrings
    var tabItemInfo: TabItemInfo = .habitsFlow
    
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
        self.showHabitsListFlow()
    }
    
    //TODO: Docstrings
    func showHabitsListFlow() {
        let habitsVC = HabitsViewController.instantiate()
        habitsVC.coordinator = self
        habitsVC.tabBarItem = UITabBarItem(title: self.tabItemInfo.title, image: self.tabItemInfo.images.unselected, tag: self.tabItemInfo.orderNumber)
        habitsVC.tabBarItem.selectedImage = self.tabItemInfo.images.selected
        self.navigationController.pushViewController(habitsVC, animated: false)
    }
    
    //TODO: Docstrings
    func showEditHabitViewController(refreshDelegate: HabitRefreshProtocol, habitToEdit: Habit) {
        let editHabitVC = AddHabitViewController.instantiate()
        let navController = UINavigationController(rootViewController: editHabitVC)
        editHabitVC.delegate = refreshDelegate
        editHabitVC.habit = habitToEdit
        editHabitVC.title = "Edit Habit"
        editHabitVC.coordinator = self
        self.navigationController.topViewController?.present(navController, animated: true)
        self.formNavigationController = navController
    }
    
    //TODO: Docstrings
    func showAddHabitViewController(refreshDelegate: HabitRefreshProtocol) {
        let addHabitVC = AddHabitViewController.instantiate()
        let navController = UINavigationController(rootViewController: addHabitVC)
        addHabitVC.delegate = refreshDelegate
        addHabitVC.coordinator = self
        self.navigationController.topViewController?.present(navController, animated: true)
        self.formNavigationController = navController
    }
    
    func childDidFinish(_ child: Coordinator?) {
        
    }
}
