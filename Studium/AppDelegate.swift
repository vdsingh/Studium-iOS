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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let themeColorValue = UserDefaults.standard.string(forKey: "themeColor"),
           let color = K.colorsDict[themeColorValue] {
            updateTheme(color: color)
        } else {
            print("$Log: no theme color saved.")
        }
        
        //        if let user = DatabaseService.shared.user {
        do {
            let assignments = DatabaseService.shared.getStudiumObjects(expecting: Assignment.self)
            for assignment in assignments {
                if(assignment.isAutoscheduled && Date() > assignment.endDate) {
                    DatabaseService.shared.deleteStudiumObject(assignment)
                }
            }
            //            } catch {
            //                print("$Error: issue accessing assignments in Realm.")
            //            }
            //            print("User IS signed in.")
        }
        //        else {
//            UserDefaults.standard.setValue("Guest", forKey: "email")
//            print("$Log: User is NOT signed in.")
//        }
        
        print("$Log: Did finish launching");
        
        //clientID must be specified for Google Authentication
        GIDSignIn.sharedInstance().clientID = Secret.clientID
        GIDSignIn.sharedInstance().serverClientID = Secret.serverClientID
        
        // Initialize Facebook SDK
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        return true
    }
    
    
    //updates the theme color of the app.
    func updateTheme(color: UIColor){
        let navAppearance = UINavigationBarAppearance()
        navAppearance.backgroundColor = color
        
        navAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.backgroundColor = color
    
        UITabBar.appearance().standardAppearance = tabAppearance
    }
    
    func changeTheme(colorKey: String){
        UserDefaults.standard.setValue(colorKey, forKey: "themeColor")
        updateTheme(color: K.colorsDict[colorKey] ?? UIColor.black)
    }
    
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    //this is all google sign in delegate stuff.
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let googleSignIn = GIDSignIn.sharedInstance().handle(url)
        if googleSignIn {
            return true
        }
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        return false
    }    
}
