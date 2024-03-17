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

final class SocialLoginViewController: UIViewController {
    private let mainLogoImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: Const.withpeaceLogo)
        
        return image
    }()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "위드피스에 오신 것을 환영합니다."
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        
        return label
    }()
    
    private let mainSubtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.numberOfLines = 0
        label.text = "1인 가구의 모든 것 \n유용한 정보를 함께 공유해보세요!"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textAlignment = .center
        
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
        button.setImage(UIImage(named: "google-logo"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .leading
        button.configuration = config
        
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
        button.setImage(UIImage(named: "apple-logo"), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .leading
        
        return button
    }()
    
    private let googleSigninManager: AuthenticationProvider
    private var viewModel = SocialLoginViewModel()
    private let disposeBag = DisposeBag()
    
    init(googleSigninManager: AuthenticationProvider) {
        self.googleSigninManager = googleSigninManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        googleLoginButton.addTarget(self, action: #selector(didTapGoogleSign), for: .touchUpInside)
    }
    
    private func setupLayout() {
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
    
    @objc private func didTapGoogleSign() {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signIn, error in
            guard error == nil else { return }
            guard let signIn = signIn else { return }
            
            let user = signIn.user
            guard let idtoken = user.idToken?.tokenString else { return }
            
            self.googleSigninManager.performGoogleSign(idToken: idtoken) { result in
                switch result {
                case .success(let data):
                    print("\(data) 토큰 주세요")
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
