//
//  AuthenticationError.swift
//  Studium
//
//  Created by Vikram Singh on 9/14/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

//TODO: Docstrings
enum AuthenticationError: Error {
    case cancelled
    case nilResult
    case nilAuthCode
    case nilUser
    case nildeviceID
    case nilAccessToken
    case registeredSuccessfullyButUserWasNil
}
