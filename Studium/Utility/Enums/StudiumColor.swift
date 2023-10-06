//
//  StudiumColor.swift
//  Studium
//
//  Created by Vikram Singh on 4/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum ThemeColorOverrideMode {
    case dark
    case light
}

/// Colors for this application
public enum StudiumColor {
    
    case background
    case secondaryBackground
    case tertiaryBackground
    
    case primaryAccent
    case secondaryAccent
    
    case primaryLabel
    case secondaryLabel
    case darkLabel
    case placeholderLabel
    
    case success
    case failure
    
    case link
    
    /// The colors for dark mode and light mode
    var colors: (dark: UIColor, light: UIColor) {
        switch self {
        case .background:
            return (UIColor(hex: "#000000"), UIColor(hex: "#FFFFFF"))
        case .secondaryBackground:
            return (UIColor(hex: "#1c1c1e"), UIColor(hex: "F2F2F7"))
        case .tertiaryBackground:
            return (UIColor(hex: "#2C2C2E"), UIColor(hex: "FFFFFF"))
        case .primaryAccent:
            return (UIColor(hex: "#4651EA"), UIColor(hex: "#4651EA"))
        case .secondaryAccent:
            return (UIColor(hex: "#EA7970"), UIColor(hex: "#EA7970"))
        case .primaryLabel:
            return (StudiumColor.background.colors.light, StudiumColor.background.colors.dark)
        case .secondaryLabel:
            return (UIColor(hex: "#79787f"), .secondaryLabel)
        case .darkLabel:
            return (UIColor(hex: "#4a4a4a"), .label)
        case .placeholderLabel:
            return (UIColor(hex: "#77777a"), UIColor(hex: "#C5C5DC"))
        case .success:
            return (UIColor(hex: "#09b000"), UIColor(hex: "#09b000"))
        case .failure:
            return (UIColor(hex: "#fc0303"), UIColor(hex: "#fc0303"))
        case .link:
            return (UIColor(hex: "#127dff"), UIColor(hex: "#127dff"))
        }
    }
    
    /// Provides the correct UIColor
    public var uiColor: UIColor {
        return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
            if let sceneDelegate = SceneDelegate.main {
                if sceneDelegate.window?.overrideUserInterfaceStyle == .dark {
                    // Return the color for Dark Mode
                    return self.colors.dark
                } else {
                    // Return the color for Light Mode
                    return self.colors.light
                }
            }
            
            if UITraitCollection.userInterfaceStyle == .dark {
                // Return the color for Dark Mode
                return self.colors.dark
            } else {
                // Return the color for Light Mode
                return self.colors.light
            }
        }
    }
    
    /// Provides the correct Color
    public var color: Color {
        Color(uiColor: self.uiColor)
    }
    
    /// Darkens the color
    /// - Parameter factor: The amount by which to darken the color
    /// - Returns: The darkened color
    func darken(by factor: CGFloat = 60) -> UIColor {
        return self.uiColor.darker(by: factor) ?? .black
    }
    
    
    /// Provides the label color for a background color
    /// - Parameter backgroundColor: The color on which the label resides
    /// - Returns: A label color
    static func primaryLabelColor(forBackgroundColor backgroundColor: UIColor) -> UIColor {
        // A contrasting color to the course's color - we don't want white text on yellow background.
        var contrastingColor = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor, isFlat: true)
        
        // Black as a label color looks too intense. If the contrasting color is supposed to be black, change it to a lighter gray.
        if contrastingColor == UIColor(contrastingBlackOrWhiteColorOn: .white, isFlat: true) {
            contrastingColor = self.darkLabel.uiColor
        }
        
        return contrastingColor
    }
    
    static func grayLabelColor(forBackgroundColor backgroundColor: UIColor) -> UIColor {
        // A contrasting color to the course's color - we don't want white text on yellow background.
        var contrastingColor = UIColor(contrastingBlackOrWhiteColorOn: backgroundColor, isFlat: true)
        
        // If the background is dark, return light gray
        if contrastingColor == UIColor(contrastingBlackOrWhiteColorOn: .white, isFlat: true) {
            contrastingColor = .lightGray
        } else {
            contrastingColor = .darkGray
        }
        
        return contrastingColor
    }
    
    static func primaryLabelColor(forBackgroundColor backgroundColor: Color) -> Color {
        let uiColor = UIColor(backgroundColor)
        let contrastingColor = self.primaryLabelColor(forBackgroundColor: uiColor)
        return Color(uiColor: contrastingColor)
    }
}
