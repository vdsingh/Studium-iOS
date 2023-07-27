//
//  StudiumIcon.swift
//  Studium
//
//  Created by Vikram Singh on 6/6/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

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

protocol CreatesUIImage {
    var uiImage: UIImage { get }
}

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

// TODO: Docstrings
enum StudiumIcon: String, CaseIterable, CreatesUIImage {
    case atom
    case baseball
    case basketball
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
    case calculate
    case calculator
    case campground
    case canadianMapleLeaf
    case cannabis
    case chart
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
    case cricket
    case database
    case display
    case divide
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
    case football
    case function
    case gameController
    case gavel
    case golfCourse
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
    case microscope
    case minus
    case moneyBill
    case moneyCheckDollar
    case monument
    case networkWired
    case otter
    case pencil
    case personHiking
    case personKayaking
    case personSkateboarding
    case personSkiingNordic
    case personSkiing
    case personSnowboarding
    case personSurfing
    case personSwimming
    case personWalkingLuggage
    case personWalking
    case pingpong
    case pizzaSlice
    case plane
    case plus
    case rightFromBracket
    case robot
    case running
    case server
    case ship
    case shower
    case snowplow
    case soap
    case soccer
    case tree
    case tv
    case user
    case utensils
    case vial
    case wallet
    case windmill
    
    
    // TODO: Docstrings
    var uiImage: UIImage {
        if let image = UIImage(named: self.rawValue) {
            return image
        } else {
            Log.e("tried to create UIImage from StudiumIcon rawValue \(self.rawValue) but failed.", logToCrashlytics: true)
            return .actions
        }
    }
}

enum StudiumIconGroup: String, CaseIterable {
    case science
    case math
    case games
    case sports
    case nature
    case computer
    case entertainment
    case chores
    case financial
    case food
    case transportation
    case symbols
    case other
    
    var icons: [StudiumIcon] {
        switch self {
        case .science:
            return [.atom, .dna, .vial, .laptopMedical, .heart, .flaskVial, .boltLightning, .microscope, .windmill]
        case .games:
            return [.chess, .chessKing, .chessKnight, .chessBishop, .chessPawn, .chessQueen, .chessRook]
        case .math:
            return [.plus, .minus, .calculator, .calculate, .divide, .chart, .function]
        case .sports:
            return [.dumbbell, .football, .basketball, .baseball, .soccer, .pingpong, .cricket, .golfCourse, .personSwimming, .personWalking, .personSkiing, .personSkiingNordic, .personSnowboarding, .personHiking, .running, .personSkateboarding, .personKayaking, .personSurfing]
        case .nature:
            return [.tree, .personHiking, .leaf, .fireBurner, .cannabis, .canadianMapleLeaf, .campground, .dog, .otter, .hippo, .feather, .bugs, .bug, .boltLightning, .binoculars]
        case .computer:
            return [.server, .robot, .networkWired, .laptopCode, .laptopMedical, .file, .fileCode, .download, .display, .database, .computer, .code, .gameController]
        case .entertainment:
            return [.tv, .gameController, .martiniGlass, .cannabis, .book, .binoculars]
        case .chores:
            return [.soap, .snowplow, .shower, .kitchenSet, .hammer, .gavel, .dog, .bath, .pencil]
        case .financial:
            return [.wallet, .moneyBill, .moneyCheckDollar, .dollarSign, .creditCard, .chart]
        case .food:
            return [.utensils, .pizzaSlice, .martiniGlass, .kitchenSet, .burger, .blender]
        case .transportation:
            return [.ship, .ferry, .plane, .personWalkingLuggage, .map]
        case .symbols:
            return [.failureMark, .clock, .checkmark, .bell, .pencil]
        case .other:
            return [.user, .monument, .landmark, .house, .folder, .building, .rightFromBracket]
        }
    }
    
    var label: String {
        return self.rawValue.capitalized
    }
}
