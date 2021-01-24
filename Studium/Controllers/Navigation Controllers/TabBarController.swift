//
//  TabBarController.swift
//  Studium
//
//  Created by Vikram Singh on 1/23/21.
//  Copyright © 2021 Vikram Singh. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let layerGradient = CAGradientLayer()

        override func viewDidLoad() {
            super.viewDidLoad()

            layerGradient.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
            layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
            layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
            layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
            self.tabBar.layer.addSublayer(layerGradient)
        }

}
