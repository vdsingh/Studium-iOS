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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabItemViewControllers = self.rootControllers().map {
            UINavigationController(rootViewController: $0)
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
    
    func rootControllers() -> [UIViewController] {
        return [
            StudiumEventListViewController<Habit>(
                tabItemConfig: .habitsList,
                viewModel: .init(
                    filter: { _ in return true },
                    separator: { habitsArr in
                        var sections: [[Habit]] = [[], []]
                        for habit in habitsArr {
                            if habit.occursToday {
                                sections[0].append(habit)
                            } else {
                                sections[1].append(habit)
                            }
                        }
                        
                        return sections
                    }
                )
            ),
            StudiumEventListViewController<Course>(
                tabItemConfig: .coursesFlow,
                viewModel: .init(
                    filter: { _ in return true },
                    separator: { coursesArr in
                        var sections: [[Course]] = [[], []]
                        for course in coursesArr {
                            if course.occursToday {
                                sections[0].append(course)
                            } else {
                                sections[1].append(course)
                            }
                        }
                        
                        return sections
                    }
                )
            ),
        ]
    }
}
