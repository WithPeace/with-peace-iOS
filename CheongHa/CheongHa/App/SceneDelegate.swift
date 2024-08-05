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
        
        // Launch Screen 보여주면서 데이터를 받아오지 못한다면 사용할 수 없도록 구현 -> indicatorView 구현 + Due Time 구현
        ProfileAPIRepository().searchProfile { result in
            switch result {
            case .success(let data):
                print(data)
                print("로그인 성공")
                DispatchQueue.main.async {
                    let tabBarController = MainTabbarController()
                    window.rootViewController = tabBarController
                    window.makeKeyAndVisible()
                }
                
            case .failure(let error):
                print(error)
                print("로그인 에러")
                DispatchQueue.main.async {
                    let socialLoginViewController = SocialLoginViewController()
                    let navigationController = UINavigationController(rootViewController: socialLoginViewController)
                    
                    window.rootViewController = navigationController
                    window.makeKeyAndVisible()
                }
            }
        }
        
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
    
    func changeViewController() {
        guard let window = window else { return }
        
        let tabBarController = MainTabbarController()
        window.rootViewController = tabBarController
    }
    
    func moveToDefaultLoginView() {
        guard let window = window else { return }
        
        let socialLoginViewController = SocialLoginViewController()
        let navigationController = UINavigationController(rootViewController: socialLoginViewController)
        
        window.rootViewController = navigationController
    }
    
    func moveToExampleView() {
        guard let window = window else { return }
        
        let exampleViewController = ExampleViewController()
        let navigationController = UINavigationController(rootViewController: exampleViewController)
        
        window.rootViewController = navigationController
    }
}
