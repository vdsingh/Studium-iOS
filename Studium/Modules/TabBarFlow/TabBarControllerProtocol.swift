//
//  TabBarControllerProtocol.swift
//  Studium
//
//  Created by Vikram Singh on 10/6/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

protocol TabBarControllerProtocol: UIViewController {
    var tabItemConfig: TabItemConfig { get }
}

extension TabBarControllerProtocol {
    func setTabBarItem() {
        self.tabBarItem = UITabBarItem(title: self.tabItemConfig.title,
                                       image: self.tabItemConfig.images.unselected,
                                       tag: self.tabItemConfig.orderNumber)
        self.tabBarItem.selectedImage = self.tabItemConfig.images.selected
    }
}
