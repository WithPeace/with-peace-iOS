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
                filterUsecase: FilterUsecase(
                    filterRepository: FilterRepository(
                        keychain: keychain,
                        network: network
                    )
                )
            )
        )
    )
    private lazy var youthPolicyViewController = UINavigationController(
        rootViewController: YouthPolicyViewController(
            viewModel: YouthPolicyViewModel(
                policyUsecase: PolicyUsecase(
                    policyRepository: PolicyRepository(
                        keychain: keychain,
                        network: network
                    )
                ),
                filterUsecase: FilterUsecase(
                    filterRepository: FilterRepository(
                        keychain: keychain,
                        network: network
                    )
                ),
                inMemoryUsecase: InMemoryUsecase(
                    inMemoryRepository: InMemoryRepository()
                )
            )
        )
    )
//    private let registBlankViewController = BlankPageViewController()
    private let communityViewController = UINavigationController(rootViewController: CommunityViewController())
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
                            communityViewController,
                            myPageViewController], animated: true)
        
        homeViewController.tabBarItem.image = UIImage(named: tabBarConstant.icHome)
        youthPolicyViewController.tabBarItem.image = UIImage(named: tabBarConstant.icYouthPolicy)
        communityViewController.tabBarItem.image = UIImage(named: tabBarConstant.icCommunity)
        myPageViewController.tabBarItem.image = UIImage(named: tabBarConstant.icMypage)
        
        homeViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icHomeSelect)
        youthPolicyViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icHomeSelect)
        communityViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icCommunitySelect)
        //        forumViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icBoardSelect)
        myPageViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icMypageSelect)
        
        homeViewController.tabBarItem.title = "홈"
        youthPolicyViewController.tabBarItem.title = "청년정책"
        communityViewController.tabBarItem.title = "커뮤니티"
        myPageViewController.tabBarItem.title = "마이페이지"
        
        homeViewController.tabBarItem.tag = 0
        youthPolicyViewController.tabBarItem.tag = 1
        communityViewController.tabBarItem.tag = 2
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
