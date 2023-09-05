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
    
    var searchTerms: [String] {
        var terms = [String]()
        terms.append(self.rawValue)
        
        switch self {
        case .atom:
            terms.append(contentsOf: ["atom", "molecul", "scien", "chem", "bio", "phys"])
        case .baseball:
            terms.append(contentsOf: ["baseball", "sport", "game", "bat"])
        case .basketball:
            terms.append(contentsOf: ["ball", "sport", "game", "hoop", "shoot"])
        case .bath:
            terms.append(contentsOf: ["bath", "hygiene", "relax", "shower"])
        case .bell:
            terms.append(contentsOf: ["bell", "notification", "ring"])
        case .binoculars:
            terms.append(contentsOf: ["binoculars", "view", "observ"])
        case .blender:
            terms.append(contentsOf: ["blen", "kitchen", "cook"])
        case .boltLightning:
            terms.append(contentsOf: ["bolt", "lightning", "electric", "power"])
        case .book:
            terms.append(contentsOf: ["book", "read", "educat"])
        case .bug:
            terms.append(contentsOf: ["bug", "insect", "nature"])
        case .bugs:
            terms.append(contentsOf: ["bugs", "insects", "nature"])
        case .building:
            terms.append(contentsOf: ["building", "architect", "construct"])
        case .burger:
            terms.append(contentsOf: ["burger", "food", "fast food", "eat"])
        case .calculate:
            terms.append(contentsOf: ["calculate", "math", "computation"])
        case .calculator:
            terms.append(contentsOf: ["calculator", "math", "computation"])
        case .campground:
            terms.append(contentsOf: ["campground", "outdoor", "nature"])
        case .canadianMapleLeaf:
            terms.append(contentsOf: ["maple leaf", "canadian", "symbol"])
        case .cannabis:
            terms.append(contentsOf: ["cannabis", "marijuana", "weed"])
        case .chart:
            terms.append(contentsOf: ["chart", "graph", "statistics"])
        case .checkmark:
            terms.append(contentsOf: ["checkmark", "done", "completed"])
        case .chessBishop:
            terms.append(contentsOf: ["chess bishop", "chess", "strategy"])
        case .chessKing:
            terms.append(contentsOf: ["chess king", "chess", "strategy"])
        case .chessKnight:
            terms.append(contentsOf: ["chess knight", "chess", "strategy"])
        case .chessPawn:
            terms.append(contentsOf: ["chess pawn", "chess", "strategy"])
        case .chessQueen:
            terms.append(contentsOf: ["chess queen", "chess", "strategy"])
        case .chessRook:
            terms.append(contentsOf: ["chess rook", "chess", "strategy"])
        case .chess:
            terms.append(contentsOf: ["chess", "strategy", "game"])
        case .clock:
            terms.append(contentsOf: ["clock", "time", "hour"])
        case .code:
            terms.append(contentsOf: ["code", "programming", "development"])
        case .computer:
            terms.append(contentsOf: ["computer", "technology", "device"])
        case .creditCard:
            terms.append(contentsOf: ["credit card", "money", "payment"])
        case .cricket:
            terms.append(contentsOf: ["cricket", "insect", "nature"])
        case .database:
            terms.append(contentsOf: ["database", "data", "storage"])
        case .display:
            terms.append(contentsOf: ["display", "screen", "monitor"])
        case .divide:
            terms.append(contentsOf: ["divide", "math", "operation"])
        case .dna:
            terms.append(contentsOf: ["dna", "genetics", "biology"])
        case .dog:
            terms.append(contentsOf: ["dog", "pet", "animal"])
        case .dollarSign:
            terms.append(contentsOf: ["dollar sign", "money", "currency"])
        case .download:
            terms.append(contentsOf: ["download", "arrow", "file"])
        case .dumbbell:
            terms.append(contentsOf: ["dumbbell", "exercise", "fitness"])
        case .failureMark:
            terms.append(contentsOf: ["failure mark", "error", "wrong"])
        case .feather:
            terms.append(contentsOf: ["feather", "bird", "nature"])
        case .ferry:
            terms.append(contentsOf: ["ferry", "boat", "transportation"])
        case .fileCode:
            terms.append(contentsOf: ["file code", "programming", "development"])
        case .file:
            terms.append(contentsOf: ["file", "document", "paper"])
        case .fireBurner:
            terms.append(contentsOf: ["fire burner", "flame", "heat"])
        case .flaskVial:
            terms.append(contentsOf: ["flask vial", "chemistry", "experiment"])
        case .folder:
            terms.append(contentsOf: ["folder", "directory", "storage"])
        case .football:
            terms.append(contentsOf: ["football", "sports", "game"])
        case .function:
            terms.append(contentsOf: ["function", "math", "equation"])
        case .gameController:
            terms.append(contentsOf: ["game controller", "gaming", "play"])
        case .gavel:
            terms.append(contentsOf: ["gavel", "law", "justice"])
        case .golfCourse:
            terms.append(contentsOf: ["golf course", "sports", "game"])
        case .hammer:
            terms.append(contentsOf: ["hammer", "tool", "construction"])
        case .heart:
            terms.append(contentsOf: ["heart", "love", "emotion"])
        case .hippo:
            terms.append(contentsOf: ["hippo", "animal", "nature"])
        case .house:
            terms.append(contentsOf: ["house", "home", "residence"])
        case .kitchenSet:
            terms.append(contentsOf: ["kitchen set", "cooking", "utensils"])
        case .landmark:
            terms.append(contentsOf: ["landmark", "monument", "famous"])
        case .laptopCode:
            terms.append(contentsOf: ["laptop code", "programming", "development"])
        case .laptopMedical:
            terms.append(contentsOf: ["laptop medical", "healthcare", "technology"])
        case .leaf:
            terms.append(contentsOf: ["leaf", "nature", "plant"])
        case .map:
            terms.append(contentsOf: ["map", "navigation", "location"])
        case .martiniGlass:
            terms.append(contentsOf: ["martini glass", "drink", "alcohol"])
        case .microscope:
            terms.append(contentsOf: ["microscope", "science", "research"])
        case .minus:
            terms.append(contentsOf: ["minus", "subtraction", "math"])
        case .moneyBill:
            terms.append(contentsOf: ["money bill", "currency", "payment"])
        case .moneyCheckDollar:
            terms.append(contentsOf: ["money check dollar", "currency", "payment"])
        case .monument:
            terms.append(contentsOf: ["monument", "landmark", "famous"])
        case .networkWired:
            terms.append(contentsOf: ["network wired", "connectivity", "technology"])
        case .otter:
            terms.append(contentsOf: ["otter", "animal", "nature"])
        case .pencil:
            terms.append(contentsOf: ["pencil", "writing", "draw"])
        case .personHiking:
            terms.append(contentsOf: ["person hiking", "outdoor", "activity"])
        case .personKayaking:
            terms.append(contentsOf: ["person kayaking", "outdoor", "activity"])
        case .personSkateboarding:
            terms.append(contentsOf: ["skateboard", "outdoor", "activity"])
        case .personSkiingNordic:
            terms.append(contentsOf: ["person kayaking", "outdoor", "activity"])
        case .personSkiing:
            terms.append(contentsOf: ["person kayaking", "outdoor", "activity"])
        case .personSnowboarding:
            terms.append(contentsOf: ["person kayaking", "outdoor", "activity"])
        case .personSurfing:
            terms.append(contentsOf: ["person kayaking", "outdoor", "activity"])
        case .personSwimming:
            terms.append(contentsOf: ["person kayaking", "outdoor", "activity"])
        case .personWalkingLuggage:
            terms.append(contentsOf: ["person kayaking", "outdoor", "activity"])
        case .personWalking:
            terms.append(contentsOf: ["person kayaking", "outdoor", "activity"])
        case .pingpong:
            terms.append(contentsOf: ["pingpong", "sports", "game"])
        case .pizzaSlice:
            terms.append(contentsOf: ["pizza slice", "food", "dining"])
        case .plane:
            terms.append(contentsOf: ["plane", "air travel", "transportation"])
        case .plus:
            terms.append(contentsOf: ["plus", "addition", "math"])
        case .rightFromBracket:
            terms.append(contentsOf: ["right from bracket", "programming", "code"])
        case .robot:
            terms.append(contentsOf: ["robot", "technology", "automation"])
        case .running:
            terms.append(contentsOf: ["running", "exercise", "activity"])
        case .server:
            terms.append(contentsOf: ["server", "technology", "data"])
        case .ship:
            terms.append(contentsOf: ["ship", "transportation", "sea"])
        case .shower:
            terms.append(contentsOf: ["shower", "hygiene", "clean"])
        case .snowplow:
            terms.append(contentsOf: ["snowplow", "winter", "snow"])
        case .soap:
            terms.append(contentsOf: ["soap", "hygiene", "clean"])
        case .soccer:
            terms.append(contentsOf: ["soccer", "sports", "game"])
        case .tree:
            terms.append(contentsOf: ["tree", "nature", "plant"])
        case .tv:
            terms.append(contentsOf: ["tv", "television", "entertainment"])
        case .user:
            terms.append(contentsOf: ["user", "profile", "person"])
        case .utensils:
            terms.append(contentsOf: ["utensils", "cooking", "kitchen"])
        case .vial:
            terms.append(contentsOf: ["vial", "chemistry", "experiment"])
        case .wallet:
            terms.append(contentsOf: ["wallet", "money", "finance"])
        case .windmill:
            terms.append(contentsOf: ["windmill", "energy", "sustainability"])
        }
        
        return terms
    }
    
    static func icons(
        fromSearchText searchText: String,
        qos: DispatchQoS.QoSClass,
        completion: @escaping ([StudiumIcon]) -> Void
    ) {
        DispatchQueue.global(qos: qos).async {
            if searchText.isEmpty {
                completion(StudiumIcon.allCases)
            } else {
                completion(StudiumIcon.allCases.filter { icon in
                    let termsToSearch = icon.searchTerms
                    return termsToSearch.contains { term in
                        term.lowercased().contains(searchText.lowercased())
                    }
                })
            }
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
