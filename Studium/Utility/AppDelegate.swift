//
//  AppDelegate.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import ChameleonFramework
import RealmSwift
import GoogleSignIn
import FBSDKLoginKit
import FirebaseAnalytics
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // TODO: Docstrings
    let databaseService = DatabaseService()
    
    // TODO: Docstrings
    lazy var autoscheduleService: AutoscheduleServiceProtocol = {
        return AutoscheduleService(databaseService: self.databaseService)
    }()
    
    let studiumEventService = StudiumEventService.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Log.d("Did finish launching");
        
        // Initialize Facebook SDK
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        FirebaseApp.configure()
        
        ColorManager.cellBackgroundColor = StudiumColor.secondaryBackground.uiColor
        ColorManager.primaryBackgroundColor = StudiumColor.background.uiColor
        ColorManager.primaryTextColor = StudiumColor.primaryLabel.uiColor
        ColorManager.placeholderTextColor = StudiumColor.placeholderLabel.uiColor
        ColorManager.primaryAccentColor = StudiumColor.primaryAccent.uiColor
        ColorManager.tableViewSeparatorColor = StudiumColor.tertiaryBackground.uiColor
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    // MARK: - Google Setup
    
    // this is all google sign in delegate stuff.
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
    
    func applicationWillTerminate(_ application: UIApplication) {
//        self.updateRecentAssignments()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("Application will resign active")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("Application did enter background")
//        self.updateRecentAssignments()
    }
}
