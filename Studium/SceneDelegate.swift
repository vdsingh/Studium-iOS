//
//  SceneDelegate.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import SwiftUI

//AUTHENTICATION
import RealmSwift
import GoogleSignIn
//import FacebookCore
import FBSDKLoginKit


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let defaults = UserDefaults.standard
    let app = App(id: Secret.appID)


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
           // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
           // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        //change initial view controller depending on whether user has decided notifications
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
//        GIDSignIn.sharedInstance().restorePreviousSignIn{ user, error in
//            if error != nil || user == nil {
//              // Show the app's signed-out state.
//                print("LOG: User is NOT signed in with Google")
//            } else {
//              // Show the app's signed-in state.
//                if let email = user?.profile?.email {
//                    print("LOG: User is signed in with Google. Restored sign-in. User Email: \(email). Going to MainTabController.")
//                    self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainTabController")
//                }else{
//                    print("ERROR: User is signed in with Google but their Email is nil.")
//                }
//            }
//        }
        
        if (app.currentUser != nil && app.currentUser!.isLoggedIn){
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "MainTabController")
        }else{
            window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "StartViewControllerNavigation")
        }
    }
    
    //Facebook code:
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

