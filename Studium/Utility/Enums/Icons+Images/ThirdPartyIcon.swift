//
//  ThirdPartyIcon.swift
//  Studium
//
//  Created by Vikram Singh on 9/9/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

enum ThirdPartyIcon: String, CaseIterable, CreatesUIImage {
    case googleCalendar
    case appleCalendar
    
    var uiImage: UIImage {
        if let image = UIImage(named: self.rawValue) {
            return image
        } else {
            Log.e("tried to create UIImage from StudiumIcon rawValue \(self.rawValue) but failed.", logToCrashlytics: true)
            return .actions
        }
    }
}
