//
//  TabItemInfo.swift
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
    case treeFlow = 4
    
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
        case .treeFlow:
            return "Tree"
        }
    }
    
    // TODO: Docstrings
    var images: (unselected: UIImage, selected: UIImage) {
        switch self {
        case .calendarFlow:
            return (SystemIcon.clock.createImage(), SystemIcon.clockFill.createImage())
        case .habitsFlow:
            return (SystemIcon.dumbbell.createImage(), SystemIcon.dumbbellFill.createImage())
        case .coursesFlow:
            return (SystemIcon.book.createImage(), SystemIcon.bookFill.createImage())
        case .toDoFlow:
            return (SystemIcon.listClipboard.createImage(), SystemIcon.listClipboardFill.createImage())
        case .treeFlow:
            return (SystemIcon.tree.createImage(), SystemIcon.treeFill.createImage())
        }
    }
    
    // TODO: Docstrings
    var orderNumber: Int {
        return self.rawValue
    }
}
