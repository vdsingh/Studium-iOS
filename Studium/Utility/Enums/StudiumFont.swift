//
//  StudiumFont.swift
//  Studium
//
//  Created by Vikram Singh on 6/10/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

enum StudiumFont {
    case title
    case subTitle
    case body
    case placeholder
    
    var font: UIFont {
        switch self {
        case .title:
            return UIFont.boldSystemFont(ofSize: 24)
        case .subTitle:
            return UIFont.systemFont(ofSize: 18, weight: .semibold)
        case .placeholder, .body:
            return UIFont.systemFont(ofSize: 16)
        }
    }
    
    var color: UIColor {
        switch self {
        case .title, .body, .subTitle:
            return StudiumColor.primaryLabel.uiColor
        case .placeholder:
            return StudiumColor.placeholderLabel.uiColor
        }
    }
}
