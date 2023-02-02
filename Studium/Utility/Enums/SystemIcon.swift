//
//  SystemIcons.swift
//  Studium
//
//  Created by Vikram Singh on 1/26/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

/// Represents system icons.
public enum SystemIcon: String, CaseIterable {
    case plus
    case minus
    case multiply
    case divide
    case function
    case pencil
    case folder
    case book
    case film
    case lightbulb
    case tv
    case heart
    case envelope
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
    
    
    func createImage() -> UIImage {
        guard let image = UIImage(systemName: self.rawValue) else {
            fatalError("$Error: couldn't create image from systemName String: \(self.rawValue)")
        }
        
        return image
    }
}
