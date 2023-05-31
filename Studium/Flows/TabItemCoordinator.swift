//
//  TabItemCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

// TODO: Docstrings
enum TabItemInfo: Int {
    case calendarFlow = 0
    case habitsFlow = 1
    case coursesFlow = 2
    case toDoFlow = 3
    
    // TODO: Docstrings
    var title: String {
        switch self {
        case .calendarFlow:
            return "Calendar"
        case .habitsFlow:
            return "Habits"
        case .coursesFlow:
            return "Courses"
        case .toDoFlow:
            return "To Do"
        }
    }
    
    // TODO: Docstrings
    var image: UIImage {
        switch self {
        case .calendarFlow:
            return .actions
        case .habitsFlow:
            return .add
        case .coursesFlow:
            return .checkmark
        case .toDoFlow:
            return .remove
        }
    }
    
    // TODO: Docstrings
    var orderNumber: Int {
        return self.rawValue
    }
}

//TODO: Docstrings
protocol TabItemCoordinator: Coordinator {
    
    // TODO: Docstrings
    var tabItemInfo: TabItemInfo { get set }
}
