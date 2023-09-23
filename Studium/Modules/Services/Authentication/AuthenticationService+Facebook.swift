//
//  AuthenticationService+Facebook.swift
//  Studium
//
//  Created by Vikram Singh on 6/16/23.
//  Copyright © 2023 Vikram Singh. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKLoginKit

/// Facebook Authentication
extension AuthenticationService {
    
    // TODO: Docstrings
    func handleLoginWithFacebook(presentingViewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        
        let loginManager = LoginManager()
        
        if AccessToken.current != nil {
            loginManager.logOut()
            return
        }
            
        loginManager.logIn(
            viewController: presentingViewController,
            configuration: LoginConfiguration(permissions: ["email"], tracking: .enabled))
        { [weak self] loginResult in
            switch loginResult {
            case .success(_, _, let accessToken):
                if let accessToken = accessToken {
                    let credentials = Credentials.facebook(accessToken: accessToken.tokenString)
                    self?.handleLogin(credentials: credentials, completion: completion)
                } else {
                    completion(.failure(AuthenticationError.nilAccessToken))
                }
                
            case .cancelled:
                completion(.failure(AuthenticationError.cancelled))
            case .failed(let error):
                completion(.failure(error))
            }
        }
    }
}
