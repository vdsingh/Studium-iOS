//
//  UIColor_Extension.swift
//  Studium
//
//  Created by Vikram Singh on 5/3/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    //TODO: Docstrings
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue: UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    //TODO: Docstrings
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    //TODO: Docstrings
    func darker(by percentage: CGFloat = 60.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    //TODO: Docstrings
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(
                red: min(red + percentage/100, 1.0),
                green: min(green + percentage/100, 1.0),
                blue: min(blue + percentage/100, 1.0),
                alpha: alpha
            )
        } else {
            return nil
        }
    }
}
