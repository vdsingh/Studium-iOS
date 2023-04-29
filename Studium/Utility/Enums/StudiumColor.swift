//
//  StudiumColor.swift
//  Studium
//
//  Created by Vikram Singh on 4/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

/// Colors for this application
public enum StudiumColor: String {
    
    case background = "#000000"
    case secondaryBackground = "#1c1c1e"
    case primaryAccent = "#4651EA"
    case primaryLabel = "#FFFFFF"
    case secondaryLabel = "#79787f"
    
    public var uiColor: UIColor {
        UIColor(hex: self.rawValue)
    }

    func darken(by factor: CGFloat = 60) -> UIColor {
        return self.uiColor.darker(by: factor) ?? .black
    }
    
}
