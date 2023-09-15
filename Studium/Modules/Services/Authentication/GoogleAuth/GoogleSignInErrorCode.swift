//
//  GoogleSignInErrorCode.swift
//  Studium
//
//  Created by Vikram Singh on 6/23/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation

enum GoogleSignInErrorCode: Int {
    case unknown = -1
    case keychain = -2
    case hasNoAuthInKeychain = -4
    case canceled = -5
    case EMM = -6
    case scopesAlreadyGranted = -8
    case mismatchWithCurrentUser = -9
    
    var popUpTitle: String {
        if self == .scopesAlreadyGranted {
            return "Permission has already been granted."
        }
        
        return "Error Authenticating with Google"
    }
    
    var popUpDescription: String {
        switch self {
        case .unknown, .keychain, .EMM, .mismatchWithCurrentUser:
            return "An unknown error occurred. Please sign out and try again."
        case .hasNoAuthInKeychain:
            return "Could not restore previous sign in. Please sign in again."
        case .canceled:
            return "Sign in was canceled."
        case .scopesAlreadyGranted:
            return "Your Google Account has already been synced."
        }
    }
    
    var popUpType: ToastPopUpType {
        if self == .scopesAlreadyGranted {
            return .success
        }
        
        return .failure
    }
    
    func showPopUpToUser() {
        PopUpService.shared.presentToast(title: self.popUpTitle, description: self.popUpDescription, popUpType: self.popUpType)
    }
    
    static func extractErrorCode(from errorString: String) -> GoogleSignInErrorCode {
        print("ERRCODE: error string:\(errorString)")
        let regexPattern = #"com.google.GIDSignIn error (-?\d+)"#
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [])
        let matches = regex.matches(in: errorString, options: [], range: NSRange(location: 0, length: errorString.count))
        
        guard let match = matches.first else {
            print("ERRCODE: NO MATCH")
            return .unknown
        }
        
        let range = match.range(at: 1)
        if let swiftRange = Range(range, in: errorString) {
            let errorCodeString = String(errorString[swiftRange])
            if let rawValue = Int(errorCodeString) {
                return GoogleSignInErrorCode(rawValue: rawValue) ?? .unknown
            }
            
            print("ERRCODE: COULDNT CAST TO INT")
        }
        
        print("ERRCODE: REACHED END")
        return .unknown
    }
}
