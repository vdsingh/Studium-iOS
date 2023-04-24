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
//
class TabBarController: RAMAnimatedTabBarController {
    
    override func viewDidLoad() {
        // Get references to the view controllers in the storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc1 = storyboard.instantiateViewController(withIdentifier: "DayScheduleNavigationController")
        let vc2 = storyboard.instantiateViewController(withIdentifier: "HabitsNavigationController")
        let vc3 = storyboard.instantiateViewController(withIdentifier: "CoursesNavigationController")
        let vc4 = storyboard.instantiateViewController(withIdentifier: "ToDoListNavigationController")
        
        // Set the view controllers in the tab bar controller
        self.setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
        let scrollAppearance = UITabBarAppearance()
        scrollAppearance.backgroundColor = StudiumColor.primaryAccent.uiColor
        self.tabBar.barTintColor = StudiumColor.primaryAccent.uiColor
        self.tabBar.backgroundColor = StudiumColor.primaryAccent.uiColor
        self.changeSelectedColor(.black, iconSelectedColor: .black)
        
        
        let items = self.animatedItems
        
        for item in items {
            item.iconColor = StudiumColor.primaryAccent.darken(by: 30)
            item.textColor = StudiumColor.primaryAccent.darken(by: 30)
        }
        
        super.viewDidLoad()
    }
}
