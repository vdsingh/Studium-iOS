//
//  StudiumIcon.swift
//  Studium
//
//  Created by Vikram Singh on 6/6/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

<<<<<<< Updated upstream:Studium/Utility/Enums/StudiumIcon.swift
// TODO: Docstrings, implement
//enum StudiumIconImageTag: String {
//    case chemistry
//    case drugs
//    case lifting
//    case medical
//    case science
//
//    var allRelatedTerms: [String] {
//        switch self {
//        case .chemistry:
//            return ["chemical", "chemicals", "chem"]
//        case .drugs:
//            <#code#>
//        case .lifting:
//            <#code#>
//        case .medical:
//            <#code#>
//        case .science:
//            <#code#>
//        }
//    }
//}

=======
>>>>>>> Stashed changes:Studium/Utility/Enums/Icons+Images/StudiumIcon.swift
// TODO: Docstrings
enum StudiumIcon: String, CaseIterable {
    
    case atom
    case bath
    case bell
    case binoculars
    case blender
    case boltLightning
    case book
    case bug
    case bugs
    case building
    case burger
    case calculator
    case campground
    case canadianMapleLeaf
    case cannabis
    case checkmark
    case chessBishop
    case chessKing
    case chessKnight
    case chessPawn
    case chessQueen
    case chessRook
    case chess
    case clock
    case code
    case computer
    case creditCard
    case database
    case display
    case dna
    case dog
    case dollarSign
    case download
    case dumbbell
    case failureMark
    case feather
    case ferry
    case fileCode
    case file
    case fireBurner
    case flaskVial
    case folder
    case gavel
    case hammer
    case heart
    case hippo
    case house
    case kitchenSet
    case landmark
    case laptopCode
    case laptopMedical
    case leaf
    case map
    case martiniGlass
    case minus
    case moneyBill
    case moneyCheckDollar
    case monument
    case networkWired
    case otter
    case personHiking
    case personSkiingNordic
    case personSkiing
    case personSnowboarding
    case personWalkingLuggage
    case personWalking
    case pizzaSlice
    case plane
    case plus
    case rightFromBracket
    case robot
    case server
    case ship
    case shower
    case snowplow
    case soap
    case tree
    case tv
    case user
    case utensils
    case vial
    case wallet
    
    
    // TODO: Docstrings
    var image: UIImage {
        if let image = UIImage(named: self.rawValue) {
            return image
        } else {
            Log.e("tried to create UIImage from StudiumIcon rawValue \(self.rawValue) but failed.", logToCrashlytics: true)
            return .actions
        }
    }
}
