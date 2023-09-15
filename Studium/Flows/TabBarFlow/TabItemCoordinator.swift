//
//  TabItemCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

/// Coordinator for tab bar tab coordinators
protocol TabItemCoordinator: NavigationCoordinator {
    
    /// Configuration for tab bar item
    var tabItemConfig: TabItemConfig { get set }
}
