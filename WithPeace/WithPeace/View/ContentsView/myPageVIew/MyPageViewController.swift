//
//  MyPageViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    private let viewModel = MyPageViewModel()
    
    private let profileView = ProfileView()
    private let seperateViewFour = CustomProfileSeparatorView(colorName: Const.CustomColor.SystemColor.gray3)
    private let profileAccountView = ProfileAccountView()
    private let seperateViewOne = CustomProfileSeparatorView(colorName: Const.CustomColor.SystemColor.gray3)
    private let profileETCView = ProfileETCView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
//        self.navigationController?.navigationBar.backgroundColor = .systemMint
//        self.navigationController?.title = "asdf" // navigation tabbbar title
        
//        navigationController?.tabBarItem.title = "마이페이지"
//        navigationController?.navigationBar.isTranslucent = false // 불투명 = false 반투명 = true
        
        configureLayout()
        setupButtonAction()
    }
    
    private func configureLayout() {
        [profileView, seperateViewFour, profileAccountView, seperateViewOne, profileETCView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview($0)
        }
        
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 8),
            profileView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 24),
            profileView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            seperateViewFour.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 16),
            seperateViewFour.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            seperateViewFour.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            seperateViewFour.heightAnchor.constraint(equalToConstant: 4)
        ])
        
        NSLayoutConstraint.activate([
            profileAccountView.topAnchor.constraint(equalTo: seperateViewFour.bottomAnchor, constant: 16),
            profileAccountView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 24),
            profileAccountView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -24),
        ])
        
        NSLayoutConstraint.activate([
            seperateViewOne.topAnchor.constraint(equalTo: profileAccountView.bottomAnchor, constant: 16),
            seperateViewOne.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 24),
            seperateViewOne.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -24),
            seperateViewOne.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            profileETCView.topAnchor.constraint(equalTo: seperateViewOne.bottomAnchor, constant: 16),
            profileETCView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 24),
            profileETCView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -24),
        ])
    }
    
    private func setupButtonAction() {
        // profileView
//        profileView.setup { [weak self] in
//            let pushingViewController =
//            self?.navigationController?.pushViewController(pushingViewController, animated: true)
//        }
        
        // profileETCView View
//        profileETCView.setup(logOutAction: { [weak self] in
//            let pushingViewController =
//            self?.navigationController?.pushViewController(pushingViewController, animated: true)
//        })
        
//        profileETCView.setup(signOutAction: { [weak self] in
//            let pushingViewController =
//            self?.navigationController?.pushViewController(pushingViewController, animated: true)
//        })
    }
}
