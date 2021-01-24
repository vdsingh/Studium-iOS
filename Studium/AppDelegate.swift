//
//  AppDelegate.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    let realm = try! Realm()
    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //print(realm.configuration.fileURL)
//        print("UserDefaults Path: ")
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        updateTheme(color: K.colorsDict[defaults.string(forKey: "themeColor") ?? "black"] ?? UIColor.black)
//        updateTheme(color: UIColor.green)
        print("Did finish launching");
        return true
    }
    
    //updates the theme color of the app.
    func updateTheme(color: UIColor){
        let appearance = UINavigationBarAppearance()
//        let colorHex = defaults.string(forKey: "themeColor")
//        var color = K.defaultThemeColor
//        if colorHex != nil{
//            color = UIColor(hexString: colorHex!)!
//        }


        appearance.backgroundColor = color
            
//            UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), andColors: [UIColor.red, UIColor.orange])
        
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        UITabBar.appearance().barTintColor = color // your color
        UITabBarAppearance().backgroundColor = color
            
//            UIColor(gradientStyle: UIGradientStyle.leftToRight, withFrame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), andColors: [UIColor.red, UIColor.orange])
        
//        UITabBarAppearance().backgroundColor = .red
    }
    
    func changeTheme(colorKey: String){
//        defaults.setColor(color: color, forKey: "themeColor") // set
        defaults.setValue(colorKey, forKey: "themeColor")
         // get
        updateTheme(color: K.colorsDict[colorKey] ?? UIColor.black)
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
