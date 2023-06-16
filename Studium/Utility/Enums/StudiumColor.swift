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
    case tertiaryBackground = "#3C3C3C"
    
    case primaryAccent = "#4651EA"
    case secondaryAccent = "#EA7970"
    
    case primaryLabel = "#FFFFFF"
    case secondaryLabel = "#79787f"
    case placeholderLabel = "#77777a"
    
    case success = "#09b000"
    case failure = "#fc0303"
    
    //TODO: Docstrings
    public var uiColor: UIColor {
        UIColor(hex: self.rawValue)
    }

    //TODO: Docstrings
    func darken(by factor: CGFloat = 60) -> UIColor {
        return self.uiColor.darker(by: factor) ?? .black
    }
    
}
