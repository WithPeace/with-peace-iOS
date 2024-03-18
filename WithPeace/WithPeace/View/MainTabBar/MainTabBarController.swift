//
//  MainTabBarController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/13/24.
//

import UIKit

final class MainTabbarController: UITabBarController {
    private let tabBarConstant = Const.CustomIcon.ICNavigationTabbar.self
    
    private let homeViewController = UIViewController()
    private let forumViewController = UIViewController()
    private let registViewController = PostViewController()
    private let myPageViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabbarContents()
        configureTabbarAppearance()
    }
    
    private func configureTabbarContents() {
        setViewControllers([homeViewController,
                            forumViewController,
                            registViewController,
                            myPageViewController], animated: true)
        
        homeViewController.tabBarItem.image = UIImage(named: tabBarConstant.icHome)
        forumViewController.tabBarItem.image = UIImage(named: tabBarConstant.icBoard)
        registViewController.tabBarItem.image = UIImage(named: tabBarConstant.icRegist)
        myPageViewController.tabBarItem.image = UIImage(named: tabBarConstant.icMypage)
        
        homeViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icHomeSelect)
//        forumViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icBoardSelect)
        myPageViewController.tabBarItem.selectedImage = UIImage(named: tabBarConstant.icMypageSelect)
        
        homeViewController.tabBarItem.title = "홈"
        forumViewController.tabBarItem.title = "게시판"
        registViewController.tabBarItem.title = "등록"
        myPageViewController.tabBarItem.title = "마이페이지"
        
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
