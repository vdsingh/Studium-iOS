//
//  FormError.swift
//  
//
//  Created by Vikram Singh on 5/14/23.
//

import Foundation
public protocol FormError {
//    associatedtype ErrorType
    var stringRepresentation: String { get }
//    static func constructErrorString(errors: [ErrorType]) -> String
}
