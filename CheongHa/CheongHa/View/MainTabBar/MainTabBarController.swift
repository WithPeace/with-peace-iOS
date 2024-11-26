//
//  MainTabBarController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/13/24.
//

import UIKit

final class MainTabbarController: UITabBarController {
    private let tabBarConstant = Const.CustomIcon.ICNavigationTabbar.self
    private var beforeSelectedTag: Int = 0
    
    private let keychain = KeychainManager()
    private let network = CleanNetworkManager()
    private lazy var homeViewController = UINavigationController(
        rootViewController: HomeViewController(
            viewModel: HomeViewModel(
                policyUsecase: PolicyUsecase(
                    policyRepository: PolicyRepository(
                        keychain: keychain,
                        network: network)
                ),
                postUsecase: PostUsecase(
                    postRepository: PostRepository(
                        keychain: keychain,
                        network: network)
                ),
                dataExchangeUsecase: DataExchangeUsecase(
                    repository: InMemoryRepository()
                )
            )
        )
    )
//    private let youthPolicyViewController = UINavigationController(rootViewController: YouthPolicyViewController())
    private let youthPolicyViewController = BlankPageViewController()
    private let registBlankViewController = BlankPageViewController()
    private let myPageViewController = UINavigationController(rootViewController: MyPageViewController())
    
    private let registViewController = BlankPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        configureTabbarContents()
        configureTabbarAppearance()
    }
    
    private func configureTabbarContents() {
        setViewControllers([homeViewController,
                            youthPolicyViewController,
                            registBlankViewController,
                            myPageViewController], animated: true)
        
        homeViewController.tabBarItem.image = UIImage(named: tabBarConstant.icHome)
        youthPolicyViewController.tabBarItem.image = UIImage(named: tabBarConstant.icBoard)
        registBlankViewController.tabBarItem.image = UIImage(named: tabBarConstant.icRegist)
        myPageViewController.tabBarItem.image = UIImage(named: tabBarConstant.icMypage)
        
        homeViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icHomeSelect)
//        forumViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icBoardSelect)
        myPageViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icMypageSelect)
        
        homeViewController.tabBarItem.title = "홈"
        youthPolicyViewController.tabBarItem.title = "청년정책"
        registBlankViewController.tabBarItem.title = "등록"
        myPageViewController.tabBarItem.title = "마이페이지"
        
        homeViewController.tabBarItem.tag = 0
        youthPolicyViewController.tabBarItem.tag = 1
        registBlankViewController.tabBarItem.tag = 2
        myPageViewController.tabBarItem.tag = 3
        
        tabBar.backgroundColor = .label
        tabBar.tintColor = .label
        tabBar.unselectedItemTintColor = .systemGray
    }
    
    private func configureTabbarAppearance() {
        let tabbarAppearance = UITabBarAppearance()
        
        tabbarAppearance.backgroundColor = .systemBackground
        tabBar.standardAppearance = tabbarAppearance
        tabBar.scrollEdgeAppearance = tabbarAppearance
    }
}

extension MainTabbarController: UITabBarControllerDelegate {
    // TODO: 3번째 Tab 클릭 시 present 로직
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        if viewController.tabBarItem.tag == 2 {
//            let postVC = PostViewController()
//            postVC.viewModel.postCreated
//                .subscribe(onNext: { [weak self] newPost in
//                    self?.forumViewController.addNewPost(newPost)
//                })
//                .disposed(by: postVC.disposeBag)
//            
//            postVC.hidesBottomBarWhenPushed = true
//            postVC.modalPresentationStyle = .fullScreen
//            self.present(postVC, animated: true, completion: nil)
//            
//            self.selectedIndex = beforeSelectedTag
//        } else {
//            beforeSelectedTag = viewController.tabBarItem.tag
//        }
//    }
}
