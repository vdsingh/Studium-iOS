//
//  TabBarController.swift
//  Studium
//
//  Created by Vikram Singh on 1/23/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

// TODO: Docstrings
class TabBarController: UITabBarController {
    
    // TODO: Docstrings
    var tabItemCoordinators: [TabItemCoordinator]
    
    // TODO: Docstrings
    init(tabItemCoordinators: [TabItemCoordinator]) {
        self.tabItemCoordinators = tabItemCoordinators

        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var tabItemViewControllers = [UIViewController]()
        for tabItemCoordinator in self.tabItemCoordinators {
            tabItemCoordinator.start()
            tabItemViewControllers.append(tabItemCoordinator.navigationController)
        }

        let standardAppearance = UITabBarAppearance()
        standardAppearance.backgroundColor = StudiumColor.primaryAccent.uiColor
        self.tabBar.standardAppearance = standardAppearance
        
        // Keeps tabBar color consistent when scrolling
        self.tabBar.backgroundColor = StudiumColor.primaryAccent.uiColor
        
        // Color of unselected items
        self.tabBar.unselectedItemTintColor = .lightGray

        // Color of selected items
        self.tabBar.tintColor = .white
        self.viewControllers = tabItemViewControllers
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
