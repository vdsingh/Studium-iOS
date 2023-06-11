//
//  NavigationCoordinator.swift
//  Studium
//
//  Created by Vikram Singh on 6/8/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

protocol NavigationCoordinator: Coordinator {
    
    //TODO: Docstrings
    var navigationController: UINavigationController { get set }
    
    //TODO: Docstrings
    init(_ navigationController: UINavigationController)
    
    init()
}
