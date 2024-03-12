//
//  AppDelegate.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/7/24.
//

import UIKit
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        googleRestorePreviousSignInWithCallback()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate  {
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        
        //TODO: GOOGLE SIGNIN
        if handled {
            return true
        }
        // Handle other custom URL types.
        // If not handled by this app, return false.
        return false
    }
    
    // 상태 복원
    private func googleRestorePreviousSignInWithCallback() {
        
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
            } else {
                // Show the app's signed-in state.
            }
        }
    }
}
