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
    
    private var viewModel = SocialLoginViewModel(googleSigninManager: SignRepository())
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
    }
    
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(mainLogoImage)
        view.addSubview(mainTitleLabel)
        view.addSubview(mainSubtitleLabel)
        view.addSubview(googleLoginButton)
        view.addSubview(appleLoginButton)
        
        NSLayoutConstraint.activate([
            mainLogoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 236),
            mainLogoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainTitleLabel.topAnchor.constraint(equalTo: mainLogoImage.bottomAnchor, constant: 40),
            mainTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            mainSubtitleLabel.topAnchor.constraint(equalTo: mainTitleLabel.bottomAnchor, constant: 24),
            mainSubtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            googleLoginButton.topAnchor.constraint(equalTo: mainSubtitleLabel.bottomAnchor, constant: 131),
            googleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            googleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            googleLoginButton.heightAnchor.constraint(equalToConstant: 55),
            
            appleLoginButton.topAnchor.constraint(equalTo: googleLoginButton.bottomAnchor, constant: 16),
            appleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            appleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            appleLoginButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
}

//MARK: bind func
extension SocialLoginViewController {
    
    private func bindViewModel() {
        googleLoginButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.performGoogleLogin()
            })
            .disposed(by: disposeBag)
        
        appleLoginButton.rx.tap
            .subscribe { [weak self] _ in
                self?.handleAuthorizationAppleIDButtonPress()
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

extension SocialLoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        print("presentationAnchor 호출")
        return self.view.window!
    }
    
    // 로그인 띄워주는 func
    func handleAuthorizationAppleIDButtonPress() {
        print("handleAuthorizationAppleIDButtonPress 호출")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.requestedScopes = []
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // 인증 성공시 호출
    func authorizationController(controller: ASAuthorizationController, 
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            guard let id = String(data: appleIDCredential.identityToken!, encoding: .utf8) else {
                return
            }
            
            self.viewModel.appleLoginSuccess.onNext(id)
            
        case let passwordCredential as ASPasswordCredential:
            print("passwordCredential: ", passwordCredential)
            print(passwordCredential.user)
            print(passwordCredential.password)
        default:
            self.viewModel.signInFailure.onNext("로그인에 실패했습니다.")
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("인증 실패, ERROR authorizationController 호출")
        self.viewModel.signInFailure.onNext("로그인에 실패했습니다.")
    }
}
