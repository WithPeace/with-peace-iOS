//
//  MyPageViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit
import RxSwift

final class MyPageViewController: UIViewController {
    
    private let viewModel = MyPageViewModel()
    private let disposeBag = DisposeBag()
    
    private let profileView = ProfileView()
    private let seperateViewFour = CustomSeparatorView(colorName: Const.CustomColor.SystemColor.gray3)
    private let profileAccountView = ProfileAccountView()
    private let seperateViewOne = CustomSeparatorView(colorName: Const.CustomColor.SystemColor.gray3)
    private let profileETCView = ProfileETCView()
    private let indicator = UIActivityIndicatorView()
    
    private var imageData: Data? = nil
    private var nickname: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureNavigation()
        configureLayout()
        setupButtonAction()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear.onNext(())
    }
    
    private func bind() {
        viewModel.profileImage
            .bind(onNext: {
                self.profileView.setup(image: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.profileNickname
            .bind(onNext: { [weak self] in
                self?.profileView.setup(nickName: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.accountEmail
            .bind(onNext: {
                self.profileAccountView.setEmailTitle($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureNavigation() {
        self.navigationController?.navigationBar.standardAppearance.configureWithDefaultBackground()
        self.navigationController?.navigationBar.backgroundColor = .systemBackground
        
        self.navigationController?.navigationBar.topItem?.title = "마이페이지"
    }
}

// MARK: Layout
extension MyPageViewController {
    
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
    
    //TODO: Button Action 추가
    private func setupButtonAction() {
        // profileView
        profileView.setup { [weak self] in
            guard let nickname = self?.nickname else { return }
            let pushingViewController = ProfileEditViewController(defaultNickname: nickname,
                                                                  defaultImageData: self?.imageData)
            self?.navigationController?.pushViewController(pushingViewController, animated: true)
        }
        
        // profileETCView View
        // logutAction
        profileETCView.setup(logOutAction: { [weak self] in
            guard let selfViewController = self else  { return }
            
            let logOutSheet = CustomAlertSheetViewController(body: "로그아웃 하시겠습니까?",
                                                             leftButtonTitle: "아니오",
                                                             leftButtonAction: selfViewController.tapLogoutLeftAlertButton,
                                                             rightButtonTitle: "예",
                                                             rightButtonAction: selfViewController.tapLogoutRightAlertButton)
            logOutSheet.modalPresentationStyle = .overFullScreen
            logOutSheet.modalTransitionStyle = .crossDissolve
            self?.present(logOutSheet, animated: true)
        })
        
        // resign
        profileETCView.setup(signOutAction: { [weak self] in
            guard let selfViewController = self else  { return }
            
            let resignSheet = CustomAlertSheetViewController(title: "탈퇴 하시겠습니까?",
                                                             body: "탈퇴 후 14일내에 복구 가능합니다.",
                                                             leftButtonTitle: "아니오",
                                                             leftButtonAction: selfViewController.tapResignLeftAlertButton,
                                                             rightButtonTitle: "예",
                                                             rightButtonAction: selfViewController.tapResignRightAlertButton)
            resignSheet.modalPresentationStyle = .overFullScreen
            resignSheet.modalTransitionStyle = .crossDissolve
            self?.present(resignSheet, animated: true)
        })
    }
    
    private func tapLogoutLeftAlertButton() {
        
    }
    
    private func tapLogoutRightAlertButton() {
        self.viewModel.tapLogoutButton.onNext(())
    }
    
    private func tapResignLeftAlertButton() {
        
    }
    
    private func tapResignRightAlertButton() {
        self.viewModel.tapResignButton.onNext(())
    }
}
