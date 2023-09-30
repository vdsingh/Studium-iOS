//
//  String_Extension.swift
//  Studium
//
//  Created by Vikram Singh on 5/3/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

// String extension for subscript access.
extension String {
    
    //TODO: Docstrings
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    //TODO: Docstrings
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    //TODO: Docstrings
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    //TODO: Docstrings
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
    
    
    //TODO: Docstrings
    func parseToInt() -> Int? {
        return Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
}
