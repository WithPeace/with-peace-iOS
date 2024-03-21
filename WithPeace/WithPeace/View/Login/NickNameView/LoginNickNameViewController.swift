//
//  LoginNickNameViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit
import RxSwift

class LoginNickNameViewController: UIViewController {
    
    private let viewModel = LoginNickNameViewModel()
    private let disposeBag = DisposeBag()
    private let bottomLayer = CALayer()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "사용할 닉네임을 정해주세요!"
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()  
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.text = "닉네임은 2~10자의 한글, 영문만 가능합니다."
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "닉네임을 입력하세요"
        textField.textAlignment = .center
        textField.borderStyle = .none
        
        return textField
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: Const.Logo.MainLogo.withpeaceLogo)
        
        return imageView
    }()
    
    private let registButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("가입 완료", for: .normal)
        button.layer.cornerRadius = 9
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        configureLayout()
        configureTargetAction()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottomLayer.removeFromSuperlayer()
        bottomLayer.backgroundColor = UIColor.black.cgColor
        bottomLayer.frame = CGRect(x: 0, y: nicknameTextField.frame.size.height - 1, width: nicknameTextField.frame.width, height: 1)
        nicknameTextField.layer.addSublayer(bottomLayer)
    }
    
    private func bind() {
        viewModel.isNicknameValid
            .subscribe {
                if $0 {
                    self.registButton.backgroundColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)
                } else {
                    self.registButton.backgroundColor = UIColor(named: Const.CustomColor.SystemColor.gray2)
                }
                self.registButton.isEnabled = $0
            }
            .disposed(by: disposeBag)
    }
}

//MARK: -objc Method
extension LoginNickNameViewController {
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        viewModel.nicknameField.onNext(textField.text)
    }
    
    @objc
    private func tapRegistButton() {
        //TODO: 완료버튼 로직수행 -> mainView
    }
    
    private func configureTargetAction() {
        registButton.addTarget(self, action: #selector(tapRegistButton), for: .touchUpInside)
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
}

//MARK: -Layout Configure
extension LoginNickNameViewController {
    
    private func configureLayout() {
        
        [titleLabel, bodyLabel, nicknameTextField, logoImageView, registButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            bodyLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            nicknameTextField.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            registButton.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 121),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            
            nicknameTextField.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 20),
                                                   
            logoImageView.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 77),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            
            registButton.heightAnchor.constraint(equalToConstant: 55),
            registButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 24),
            registButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -24),
            registButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -43)
        ])
    }
}
