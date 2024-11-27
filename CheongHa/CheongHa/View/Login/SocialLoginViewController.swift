//
//  SocialLoginViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit
import GoogleSignIn
import RxSwift
import RxCocoa
import AuthenticationServices

final class SocialLoginViewController: UIViewController {
    
    private lazy var toastMessage = ToastMessageView(superView: self.view)
    
    private let mainLogoImage: UIImageView = {
        let image = UIImageView()
        
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: Const.Logo.MainLogo.cheonghaMainLogo)
        
        return image
    }()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.text = "청하에 오신 것을 환영합니다."
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: Const.CustomColor.SystemColor.black)
        
        return label
    }()
    
    private let mainSubtitleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "청년을 위한 모든 것,\n유용한 정보를 함께 공유해보세요!"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: Const.CustomColor.SystemColor.black)
        
        return label
    }()
    
    private let googleLoginButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .leading
        config.imagePadding = 54
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Google로 로그인하기", for: .normal)
        button.backgroundColor = .white
        button.setImage(UIImage(named: Const.Logo.MainLogo.googleLogo), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    private let appleLoginButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.imagePlacement = .leading
        config.imagePadding = 62
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        
        let button = UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Apple로 로그인하기", for: .normal)
        button.backgroundColor = .white
        button.setImage(UIImage(named: Const.Logo.MainLogo.appleLogo), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    private let takeTourButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("둘러보기", for: .normal)
        button.setTitleColor(UIColor(named: Const.CustomColor.SystemColor.gray2), for: .normal)
        
        return button
    }()
    
    private let logoContentView: UIView = {
        var view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let buttonView: UIView = {
        var view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var viewModel = SocialLoginViewModel(
        googleSigninManager: SignRepository(),
        socialLoginRouter: SocialLoginRouter(),
        loginUsecase: LoginUsecase(
            loginRepository: LoginRepository(
                keychain: KeychainManager(),
                network: CleanNetworkManager()
            )
        )
    )
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        bindViewModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureLayout()
        takeTourButtonTargeting()
    }
    
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoContentView)
        view.addSubview(buttonView)
        
        [mainLogoImage, mainTitleLabel, mainSubtitleLabel].forEach {
            logoContentView.addSubview($0)
        }
        
        [googleLoginButton, appleLoginButton, takeTourButton].forEach {
            buttonView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            logoContentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoContentView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            
            buttonView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            buttonView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            buttonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -43),
        ])
        
        NSLayoutConstraint.activate([
            mainLogoImage.topAnchor.constraint(equalTo: logoContentView.topAnchor),
            mainLogoImage.centerXAnchor.constraint(equalTo: logoContentView.centerXAnchor),
            mainLogoImage.heightAnchor.constraint(equalToConstant: 150),
            mainLogoImage.widthAnchor.constraint(equalToConstant: 150),
            
            mainTitleLabel.topAnchor.constraint(equalTo: mainLogoImage.bottomAnchor, constant: 40),
            mainTitleLabel.centerXAnchor.constraint(equalTo: logoContentView.centerXAnchor),
            
            mainSubtitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 24),
            mainSubtitleLabel.centerXAnchor.constraint(equalTo: logoContentView.centerXAnchor),
            mainSubtitleLabel.bottomAnchor.constraint(equalTo: logoContentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            googleLoginButton.topAnchor.constraint(equalTo: buttonView.topAnchor),
            googleLoginButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            googleLoginButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 55),
            
            appleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 16),
            appleLoginButton.leadingAnchor.constraint(equalTo: buttonView.leadingAnchor),
            appleLoginButton.trailingAnchor.constraint(equalTo: buttonView.trailingAnchor),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 55),
//            appleLoginButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor),
            
            takeTourButton.topAnchor.constraint(equalTo: appleLoginButton.bottomAnchor, constant: 16),
            takeTourButton.bottomAnchor.constraint(equalTo: buttonView.bottomAnchor),
            takeTourButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor)
        ])
    }
}

//MARK: bind func
extension SocialLoginViewController {
    
    private func bindViewModel() {
        googleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.routeToGoogleLoginView()
            })
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .subscribe { [weak self] _ in
//                self?.handleAuthorizationAppleIDButtonPress()
                self?.viewModel.handleAuthorizationAppleIDButtonPress()
            }.disposed(by: disposeBag)
        
        viewModel.signInSuccess
            .subscribe(onNext: { datas in
                print("SignIn Success: \(datas.token)")
                
                switch datas.role {
                case .guest:
                    DispatchQueue.main.async {
                        let termsViewController = TermsViewController()
                        self.navigationController?.pushViewController(termsViewController, animated: true)
                    }
                case .user:
                    DispatchQueue.main.async {
                        guard let app = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                        app.changeViewController()
                    }
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.signInFailure
            .subscribe(onNext: { errorMessage in
                DispatchQueue.main.async {
                    self.toastMessage.presentStandardToastMessage(errorMessage)
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: 둘러보기 버튼
extension SocialLoginViewController {
    private func takeTourButtonTargeting() {
        takeTourButton.addTarget(self, action: #selector(tapTourButton), for: .touchUpInside)
    }
    
    @objc
    private func tapTourButton() {
        DispatchQueue.main.async {
            
            guard let app = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
            app.moveToExampleView()
        }
    }
}
