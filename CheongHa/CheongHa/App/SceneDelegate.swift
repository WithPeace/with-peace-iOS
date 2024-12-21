//
//  SceneDelegate.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/7/24.
//

import UIKit
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    private let disposeBag = DisposeBag()
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow(windowScene: windowScene)

//        window?.rootViewController = CommunityViewController()
//        window?.makeKeyAndVisible()
        let keychain = KeychainManager()
        let network = CleanNetworkManager()
        let profileRepository = CleanProfileRepository(keychain: keychain, network: network)
        let profileUsecase = ProfileUsecase(profileRepository: profileRepository)
        let appViewModel = AppViewModel(profileUsecase: profileUsecase)
        
        // Launch Screen 보여주면서 데이터를 받아오지 못한다면 사용할 수 없도록 구현 -> indicatorView 구현 + Due Time 구현
        bind(viewModel: appViewModel)
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
    
    func bind(viewModel: AppViewModel) {
        let input = AppViewModel.Input(initializeApp: Observable.just(()))
        let output = viewModel.transform(input: input)
        output.profile
            .drive(with: self) { owner, profile in
                if profile.error == nil {
                    print(profile.data)
                    print("로그인 성공")
                    DispatchQueue.main.async {
                        let tabBarController = MainTabbarController()
                        owner.window?.rootViewController = tabBarController
                    }
                } else {
                    print(profile.error)
                    print("로그인 에러")
                    DispatchQueue.main.async {
                        let socialLoginViewController = SocialLoginViewController()
                        let navigationController = UINavigationController(rootViewController: socialLoginViewController)
                        
                        owner.window?.rootViewController = navigationController
                    }
                }
                owner.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
    }
}
