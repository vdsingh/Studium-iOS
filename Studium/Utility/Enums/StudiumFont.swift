//
//  StudiumFont.swift
//  Studium
//
//  Created by Vikram Singh on 6/10/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum StudiumFont {
    case title
    case subTitle
    case body
    case bodySemibold
    case placeholder
    case subText
    
    var uiFont: UIFont {
        switch self {
        case .title:
            return UIFont.boldSystemFont(ofSize: 30)
        case .subTitle:
            return UIFont.systemFont(ofSize: 24, weight: .semibold)
        case .placeholder, .body:
            return UIFont.systemFont(ofSize: 18)
        case .bodySemibold:
            return UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .subText:
            return UIFont.systemFont(ofSize: 14)
        }
    }
    
    var font: Font {
        return Font(self.uiFont)
    }
    
    var uiColor: UIColor {
        switch self {
        case .title, .body, .subTitle, .bodySemibold:
            return StudiumColor.primaryLabel.uiColor
        case .placeholder, .subText:
            return StudiumColor.placeholderLabel.uiColor
        }
    }
    
    var color: Color {
        return Color(uiColor: self.uiColor)
    }
}
