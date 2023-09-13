//
//  TabItemCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 5/30/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

//TODO: Docstrings
protocol TabItemCoordinator: NavigationCoordinator {
    
    ///
    var tabItemInfo: TabItemConfig { get set }
}
