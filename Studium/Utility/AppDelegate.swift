//
//  AppDelegate.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import ChameleonFramework

//AUTHENTICATION
import RealmSwift
import GoogleSignIn
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let debug = false
    
    let databaseService = DatabaseService()
    
    lazy var autoscheduleService: AutoscheduleServiceProtocol = {
        return AutoscheduleService(databaseService: self.databaseService)
    }()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//        let assignments = self.databaseService.getStudiumObjects(expecting: Assignment.self)
//        for assignment in assignments {
//            if(assignment.isAutoscheduled && Date() > assignment.endDate) {
//                self.databaseService.deleteStudiumObject(assignment)
//            }
//        }

        printDebug("Did finish launching");
        
        //clientID must be specified for Google Authentication
//        GIDSignIn.sharedInstance.configuration?.clientID
//        GIDSignIn.sharedInstance.configuration?.clientID =
        
        //TODO: Fix google sign in.
//        GIDSignIn.sharedInstance.
//        GIDSignIn.sharedInstance().cli
//        GIDSignIn.sharedInstance.configuration?.clientID = Secret.clientID
//        GIDSignIn.sharedInstance.configuration?.serverClientID = Secret.serverClientID
        
        // TODO: Implement
//        AuthenticationService.shared.attemptRestorePreviousSignIn(completion: { status in
//            
//            
//        })
//        return true
        
        // Initialize Facebook SDK
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        return true
    }
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    
    // MARK: - Google Setup
    //this is all google sign in delegate stuff.
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        return false
    }
    
    
}

extension AppDelegate: Debuggable {
    func printDebug(_ message: String) {
        if self.debug {
            print("$LOG (AppDelegate): \(message)")
        }
    }
}
