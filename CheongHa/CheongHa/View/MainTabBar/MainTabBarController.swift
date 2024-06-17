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
    
    private let homeViewController = UINavigationController(rootViewController: HomeViewController())
    private let registBlankViewController = UIViewController()
    private let registViewController = PostViewController()
    private let myPageViewController = UINavigationController(rootViewController: MyPageViewController())
    
    private let forumViewController = ForumViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        configureTabbarContents()
        configureTabbarAppearance()
    }
    
    private func configureTabbarContents() {
        setViewControllers([homeViewController,
                            forumViewController,
                            registBlankViewController,
                            myPageViewController], animated: true)
        
        homeViewController.tabBarItem.image = UIImage(named: tabBarConstant.icHome)
        forumViewController.tabBarItem.image = UIImage(named: tabBarConstant.icBoard)
        registBlankViewController.tabBarItem.image = UIImage(named: tabBarConstant.icRegist)
        myPageViewController.tabBarItem.image = UIImage(named: tabBarConstant.icMypage)
        
        homeViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icHomeSelect)
//        forumViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icBoardSelect)
        myPageViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icMypageSelect)
        
        homeViewController.tabBarItem.title = "홈"
        forumViewController.tabBarItem.title = "게시판"
        registBlankViewController.tabBarItem.title = "등록"
        myPageViewController.tabBarItem.title = "마이페이지"
        
        homeViewController.tabBarItem.tag = 0
        forumViewController.tabBarItem.tag = 1
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
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.tabBarItem.tag == 2 {
            let postVC = PostViewController()
            postVC.viewModel.postCreated
                .subscribe(onNext: { [weak self] newPost in
                    self?.forumViewController.addNewPost(newPost)
                })
                .disposed(by: postVC.disposeBag)
            
            postVC.hidesBottomBarWhenPushed = true
            postVC.modalPresentationStyle = .fullScreen
            self.present(postVC, animated: true, completion: nil)
            
            self.selectedIndex = beforeSelectedTag
        } else {
            beforeSelectedTag = viewController.tabBarItem.tag
        }
    }
}
