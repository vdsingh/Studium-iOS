//
//  StudiumEventColor.swift
//  Studium
//
//  Created by Vikram Singh on 8/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum StudiumEventColor: String, CaseIterable, Identifiable {
    case darkRed = "9e0142"
    case red = "d53e4f"
    case orange = "f46d43"
    case lightOrange = "fdae61"
    case yellow = "fee08b"
    case lightYellow = "e6f598"
    case lightGreen = "abdda4"
    case green = "66c2a5"
    case blue = "3288bd"
    case purple = "5e4fa2"
    
    var id: String {
        self.rawValue
    }
    
    var uiColor: UIColor {
        return UIColor(hex: self.rawValue)
    }
    
    var color: Color {
        return Color(uiColor: self.uiColor)
    }
    
    static var allCasesUIColors: [UIColor] {
        return StudiumEventColor.allCases.map({ $0.uiColor })
    }
    
//    static var groupedColors: [[StudiumEventColor]] = [
//        [.darkRed, .red, .orange, .lightOrange, .yellow],
//        [.lightYellow, .lightGreen, .green, .blue, .purple]
//    ]
}
