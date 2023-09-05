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

/// Colors for this application
public enum StudiumColor: String {
    
    case background = "#000000"
    case secondaryBackground = "#1c1c1e"
    case tertiaryBackground = "#3C3C3C"
    
    case primaryAccent = "#4651EA"
    case secondaryAccent = "#EA7970"
    
    case primaryLabel = "#FFFFFF"
    case secondaryLabel = "#79787f"
    case darkLabel = "#4a4a4a"
    case placeholderLabel = "#77777a"
    
    case success = "#09b000"
    case failure = "#fc0303"
    
    case link = "127dff"
    
    //TODO: Docstrings
    public var uiColor: UIColor {
        UIColor(hex: self.rawValue)
    }
    
    public var color: Color {
        Color(uiColor: self.uiColor)
    }

    //TODO: Docstrings
    func darken(by factor: CGFloat = 60) -> UIColor {
        return self.uiColor.darker(by: factor) ?? .black
    }
    
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
}
