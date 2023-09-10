//
//  DateFormat.swift
//
//
//  Created by Vikram Singh on 5/14/23.
//

import Foundation

// TODO: Docstrings
public enum DateFormat: String {
    case standardTime = "h:mm a"
    case fullDateWithTime = "MMM d, h:mm a"
    
    public var formatString: String {
        return self.rawValue
    }
}
