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
enum TabItemConfig: Int {
    case calendarFlow = 0
    case habitsList = 1
    case coursesFlow = 2
    case toDoFlow = 3
    case treeFlow = 4
    case unknown
    
    // TODO: Docstrings
    var title: String {
        switch self {
        case .calendarFlow:
            return "Calendar"
        case .habitsList:
            return "Habits"
        case .coursesFlow:
            return "Courses"
        case .toDoFlow:
            return "To Do"
        case .treeFlow:
            return "Tree"
        case .unknown:
            return "Unknown"
        }
    }
    
    // TODO: Docstrings
    var images: (unselected: UIImage, selected: UIImage) {
        switch self {
        case .calendarFlow:
            return (SystemIcon.clock.createImage(), SystemIcon.clockFill.createImage())
        case .habitsList:
            return (SystemIcon.heart.createImage(), SystemIcon.heartFill.createImage())
        case .coursesFlow:
            return (SystemIcon.book.createImage(), SystemIcon.bookFill.createImage())
        case .toDoFlow:
            if #available(iOS 16.0, *) {
                return (SystemIcon.listClipboard.createImage(), SystemIcon.listClipboardFill.createImage())
            } else {
                return (StudiumIcon.clipboardRegular.createTabBarIcon(), StudiumIcon.clipboardSolid.createTabBarIcon())
            }
        case .treeFlow:
            return (SystemIcon.tree.createImage(), SystemIcon.treeFill.createImage())
        case .unknown:
            return (.actions, .actions)
        }
    }
    
    // TODO: Docstrings
    var orderNumber: Int {
        return self.rawValue
    }
}
