//
//  Storyboarded.swift
//  Studium
//
//  Created by Vikram Singh on 5/28/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

// TODO: Docstrings
protocol Storyboarded {
    
    // TODO: Docstrings
    static func instantiate() -> Self
}

// TODO: Docstrings
extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
