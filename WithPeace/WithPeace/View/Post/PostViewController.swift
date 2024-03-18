//
//  PostViewController.swift
//  WithPeace
//
//  Created by Hemg on 3/18/24.
//

import UIKit
import RxSwift

final class PostViewController: UIViewController {
    
    private let customNavigationBarView = PostNavigationBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCustomNaviBar()
        didTapBack()
        didTapComplete()
    }
    
    private func setupCustomNaviBar() {
        view.backgroundColor = .systemBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        customNavigationBarView.backgroundColor = .systemBackground
        view.addSubview(customNavigationBarView)
        customNavigationBarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customNavigationBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavigationBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBarView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func didTapBack() {
        customNavigationBarView.onBackButtonTapped = { [weak self] in
            self?.didTapBack()
        }
    }
    
    private func didTapComplete() {
        customNavigationBarView.onCompleteButtonTapped = { [weak self] in
            self?.didTapCompleteButton()
        }
    }
   
    private func didTapCompleteButton() {
        // 버튼 동작
        print("게시글등록")
    }
    
    private func didTapBackButton() {
        print("뒤로")
        //        navigationController?.popViewController(animated: true)
        //        self.dismiss(animated: true)
    }
}
