//
//  SceneDelegate.swift
//  Studium
//
//  Created by Vikram Singh on 5/24/20.
//  Copyright © 2020 Vikram Singh. All rights reserved.
//

import UIKit
import SwiftUI
import FBSDKLoginKit

protocol ForegroundSubscriber {
    func willEnterForeground()
}

var currentScene: UIScene?

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    let studiumEventService = StudiumEventService.shared
    
    private var willEnterForegroundSubscribers = [ForegroundSubscriber]()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let coordinator = AppCoordinator(authenticationService: AuthenticationService.shared)
        self.coordinator = coordinator
        coordinator.start()
        
        self.window?.makeKeyAndVisible()
        currentScene = scene
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        // Required by FB:
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
    
    func changeRootViewController(_ viewController: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            guard let window = self.window else {
                Log.s(SceneDelegateError.nilWindow, additionalDetails: "Tried to change root viewController, but window was nil.")
                return
            }
            
            window.rootViewController = viewController
            
            if animated {
                // add animation
                UIView.transition(with: window,
                                  duration: 0.5,
                                  options: [.transitionFlipFromLeft],
                                  animations: nil,
                                  completion: nil)
            }
        }
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
        
//        self.studiumEventService.updateFromWidget()
        DispatchQueue.main.async {
            for subscriber in self.willEnterForegroundSubscribers {
                subscriber.willEnterForeground()
            }
        }
    }
    
    func addForegroundSubscriber(_ foregroundSubscriber: ForegroundSubscriber) {
        self.willEnterForegroundSubscribers.append(foregroundSubscriber)
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

// Here is a convenient view controller extension.
extension UIViewController {
    var sceneDelegate: SceneDelegate? {
        for scene in UIApplication.shared.connectedScenes {
            if scene == currentScene,
               let delegate = scene.delegate as? SceneDelegate {
                return delegate
            }
        }
        return nil
    }
}

enum SceneDelegateError: Error {
    case nilWindow
}
