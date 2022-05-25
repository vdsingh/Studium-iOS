//
//  TabBarLogic.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/22.
//  Copyright © 2022 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

class TabBarLogic: UITabBarController{
    
    override func viewDidLoad() {
        
//        let vc1 = UINavigationController(rootViewController: ToDoListViewControllerNEW())
        let vc2 = UINavigationController(rootViewController: CoursesListViewControllerNEW())
        let vc3 = UINavigationController(rootViewController: CourseViewControllerNEW())
        
//        vc1.title = "To Do List"
        vc2.title = "Courses"
        vc3.title = "Course"
        
        self.setViewControllers([vc2, vc3], animated: true)
        self.tabBar.backgroundColor = .blue
    }
    
}
