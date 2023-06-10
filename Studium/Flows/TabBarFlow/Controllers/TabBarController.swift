//
//  TabBarController.swift
//  Studium
//
//  Created by Vikram Singh on 1/23/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

//TODO: Delete
class TabBarController: UITabBarController, Debuggable {
    
    let debug = true
    
//    let appCoordinator = AppCoordinator(UINavigationController())
    var tabItemCoordinators: [TabItemCoordinator]
    
    init(tabItemCoordinators: [TabItemCoordinator]) {
        self.tabItemCoordinators = tabItemCoordinators

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.printDebug("TabBarController viewDidLoad")

        var tabItemViewControllers = [UIViewController]()
        for tabItemCoordinator in tabItemCoordinators {
            tabItemCoordinator.start(replaceRoot: false)
            tabItemViewControllers.append(tabItemCoordinator.navigationController)
        }

//        let scrollAppearance = UITabBarAppearance()
//        scrollAppearance.backgroundColor = StudiumColor.primaryAccent.uiColor
//        scrollAppearance.backgroundColor = .yellow
        
        
        self.tabBar.unselectedItemTintColor = .lightGray
        self.tabBar.backgroundColor = StudiumColor.primaryAccent.uiColor
        self.tabBar.barTintColor = 
//        StudiumColor.primaryAccent.uiColor
        // barTintColor is "selected color"
        self.tabBar.tintColor = .white

        self.viewControllers = tabItemViewControllers
        
        printDebug("TabBarController viewControllers: \(self.viewControllers)")
    }
}
