//
//  FlatImage.swift
//  Studium
//
//  Created by Vikram Singh on 6/20/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

enum FlatImage: String, CreatesUIImage {
    case travelingAndSports
    case girlSittingOnBooks
    case womanFlying
    
    var uiImage: UIImage {
        if let image = UIImage(named: self.rawValue) {
            return image
        } else {
            Log.e("tried to create UIImage from FlatImage rawValue \(self.rawValue) but failed.", logToCrashlytics: true)
            return .actions
        }
    }
}
