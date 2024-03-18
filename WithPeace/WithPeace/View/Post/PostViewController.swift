//
//  PostViewController.swift
//  WithPeace
//
//  Created by Hemg on 3/18/24.
//

import UIKit
import RxSwift

final class PostViewController: UIViewController {
 
    let customNavBarView = UIView()
    let customTitleLabel = UILabel()
    let completeButton = UIButton()
    let backButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomNaviBar()
        setupNaviBackButton()
        setupNaviBarLabel()
        setupNaviBarButton()
    }
    
    private func setupCustomNaviBar() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        customNavBarView.backgroundColor = .systemBackground
        view.addSubview(customNavBarView)
        customNavBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBarView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupNaviBackButton() {
        customNavBarView.addSubview(backButton)
        backButton.setImage(UIImage(named: Const.CustomIcon.ICBtnPostcreate.icSignBack), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: customNavBarView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: customNavBarView.centerYAnchor)
        ])
    }
    
    private func setupNaviBarLabel() {
        customTitleLabel.text = "글 쓰기"
        customNavBarView.addSubview(customTitleLabel)
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTitleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 24),
            customTitleLabel.centerYAnchor.constraint(equalTo: customNavBarView.centerYAnchor)
        ])
    }
    
    private func setupNaviBarButton() {
        customNavBarView.addSubview(completeButton)
        completeButton.setImage(UIImage(named: Const.CustomIcon.ICBtnPostcreate.btnPostcreateDone), for: .normal)
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.trailingAnchor.constraint(equalTo: customNavBarView.trailingAnchor, constant: -24),
            completeButton.centerYAnchor.constraint(equalTo: customNavBarView.centerYAnchor)
        ])
    }
    
    @objc func completeButtonTapped() {
        // 버튼 동작
        print("게시글등록")
    }
    
    @objc func didTapBack() {
        print("뒤로")
        self.dismiss(animated: true)
    }
}
