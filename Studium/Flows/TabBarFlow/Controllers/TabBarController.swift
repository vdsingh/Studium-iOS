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
        // Get references to the view controllers in the storyboard
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc1 = storyboard.instantiateViewController(withIdentifier: "DayScheduleNavigationController")
//        let vc2 = storyboard.instantiateViewController(withIdentifier: "HabitsNavigationController")
//        let vc3 = storyboard.instantiateViewController(withIdentifier: "CoursesNavigationController")
//        let vc4 = storyboard.instantiateViewController(withIdentifier: "ToDoListNavigationController")
        
        // Set the view controllers in the tab bar controller
//        self.setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        var tabItemViewControllers = [UIViewController]()
        for tabItemCoordinator in tabItemCoordinators {
            tabItemCoordinator.start(replaceRoot: false)
            tabItemViewControllers.append(tabItemCoordinator.navigationController)
        }
        
//        self.setViewControllers(<#T##viewControllers: [UIViewController]?##[UIViewController]?#>, animated: <#T##Bool#>)
//        self.setViewControllers(tabItemViewControllers, animated: true)

        let scrollAppearance = UITabBarAppearance()
        scrollAppearance.backgroundColor = StudiumColor.primaryAccent.uiColor
        
        
        
        
        
        self.tabBar.unselectedItemTintColor = .lightGray
//        self.tabBar.barTintColor = StudiumColor.primaryAccent.uiColor
        
        
        
        self.tabBar.backgroundColor = StudiumColor.primaryAccent.uiColor
        
        // barTintColor is "selected color"
        self.tabBar.tintColor = .white
        
        

//        self.changeSelectedColor(.black, iconSelectedColor: .black)
        
        
//        let items = self.animatedItems
//
//        for item in items {
//            item.iconColor = StudiumColor.primaryAccent.darken(by: 30)
//            item.textColor = StudiumColor.primaryAccent.darken(by: 30)
//        }
        
        
//        self.appCoordinator.start()
        self.viewControllers = tabItemViewControllers
        
        printDebug("TabBarController viewControllers: \(self.viewControllers)")
    }
}
