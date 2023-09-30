//
//  UIViewController+NavigationStyle.swift
//  Studium
//
//  Created by Vikram Singh on 9/24/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func setStudiumFormNavigationStyle() {
        let navBarBackgroundColor = StudiumFormNavigationConstants.navBarBackgroundColor
        UINavigationBar.appearance().backgroundColor = navBarBackgroundColor.uiColor
        UINavigationBar.appearance().barTintColor = navBarBackgroundColor.uiColor
        UINavigationBar.appearance().tintColor = navBarBackgroundColor.uiColor
    }
}
