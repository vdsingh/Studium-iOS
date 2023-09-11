//
//  SystemIcons.swift
//  Studium
//
//  Created by Vikram Singh on 1/26/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import UIKit

/// Represents system icons.
public enum SystemIcon: String, CaseIterable, CreatesUIImage {
    case tree
    case treeFill = "tree.fill"
    case paragraphSign = "paragraphsign"
    case link
    case paperclip
    case trashCan = "trash.fill"
    case trashCanCircleFill = "trash.circle.fill"
    case listClipboard = "list.clipboard"
    case listClipboardFill = "list.clipboard.fill"
    case calendar
    case calendarExclamation = "calendar.badge.exclamationmark"
    case calendarClock = "calendar.badge.clock"
    case clock
    case clockFill = "clock.fill"
    case circle
    case circleFill = "circle.fill"
    case circleCheckmarkFill = "checkmark.circle.fill"
    case dumbbell
    case dumbbellFill = "dumbbell.fill"
    case book
    case bookFill = "book.fill"
    case plus
    case minus
    case minusCircle = "minus.circle.fill"
    case multiply
    case divide
    case function
    case pencil
    case pencilCircleFill = "pencil.circle.fill"
    case folder
    case eye
    case film
    case lightbulb
    case tv
    case heart
    case heartFill = "heart.fill"
    case envelope
    case lock
    case sunMax = "sun.max"
    case moon
    case zzz
    case sparkles
    case cloud
    case mic
    case message
    case phone
    case paperplane
    case hammer
    case map
    case gamecontroller
    case headphones
    case car
    case airplane
    case bolt
    case creditcard
    case cart
    case atom
    case cross
    case leaf
    case lungs
    case comb
    case guitars
    case laptopcomputer
    case cpu
    case ipad
    case ipodtouch
    case wrenchAndScrewdriver = "wrench.and.screwdriver"
    case gearshape
    case graduationcap
    case exclamationmarkCircle = "exclamationmark.circle"
    case a = "a.circle"
    case b = "b.circle"
    case c = "c.circle"
    case d = "d.circle"
    case e = "e.circle"
    case f = "f.circle"
    case g = "g.circle"
    case h = "h.circle"
    case i = "i.circle"
    case j = "j.circle"
    case k = "k.circle"
    case l = "l.circle"
    case m = "m.circle"
    case n = "n.circle"
    case o = "o.circle"
    case p = "p.circle"
    case q = "q.circle"
    case r = "r.circle"
    case s = "s.circle"
    case t = "t.circle"
    case u = "u.circle"
    case v = "v.circle"
    case w = "w.circle"
    case x = "x.circle"
    case y = "y.circle"
    case z = "z.circle"
    case one = "1.circle"
    case two = "2.circle"
    case three = "3.circle"
    case four = "4.circle"
    case five = "5.circle"
    case six = "6.circle"
    case seven = "7.circle"
    case eight = "8.circle"
    case nine = "9.circle"
    case ten = "10.circle"
    case chevronUp = "chevron.up"
    case chevronDown = "chevron.down"
    case chevronRight = "chevron.right"
    
    //TODO: Docstrings
    public func createImage(withConfiguration configuration: UIImage.Configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
) -> UIImage {
        
        guard let image = UIImage(systemName: self.rawValue, withConfiguration: configuration) else {
            return .actions
//            fatalError("$ERR: couldn't create image from systemName String: \(self.rawValue)")
        }
        
        return image
    }
    
    //    var uiImage: UIImage {
    //        return self.createImage()
    var uiImage: UIImage {
        if let image = UIImage(systemName: self.rawValue) {
            return image
        } else {
            Log.e("tried to create UIImage from StudiumIcon rawValue \(self.rawValue) but failed.", logToCrashlytics: true)
            return .actions
        }
    }
    //    }
}
