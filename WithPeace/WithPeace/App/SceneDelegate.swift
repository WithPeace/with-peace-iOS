//
//  SceneDelegate.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/7/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        if hasToken() {
            //기존 로그인
            let tabBarController = MainTabbarController()
            let navigationController = UINavigationController(rootViewController: tabBarController)
            
            window.rootViewController = navigationController
        } else {
            //최초 로그인
            let socialLoginViewController = SocialLoginViewController()
            let navigationController = UINavigationController(rootViewController: socialLoginViewController)
            
            window.rootViewController = navigationController
        }
        
        window.makeKeyAndVisible()
        
        self.window = window
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    private func hasToken() -> Bool {
        let keyChainManager = KeychainManager()
        guard keyChainManager.get(account: "accessToken") != nil else {
            return false
        }
        
        return true
    }
    
    func changeViewController() {
        let tabBarController = MainTabbarController()
        let navigationController = UINavigationController(rootViewController: tabBarController)
        
        guard let window = window else { return }
        window.rootViewController = navigationController
    }
}
