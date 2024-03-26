//
//  LoginNickNameViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit
import RxSwift
import Photos

class LoginNickNameViewController: UIViewController {
    
    private let viewModel = LoginNickNameViewModel()
    private let disposeBag = DisposeBag()
    private let bottomLayer = CALayer()
    private var toastMessage: ToastMessageView?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "프로필을 설정해주세요!"
        label.font = .preferredFont(forTextStyle: .title3)
        
        return label
    }()  
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        
        #warning("Profile default Image Change")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.image = UIImage(named: Const.Logo.MainLogo.withpeaceLogo)
        
        return imageView
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
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .red
        label.font = .preferredFont(forTextStyle: .caption1)
        
        return label
    }()
    
    private let registButton: UIButton = {
        let button = UIButton()
       
        button.backgroundColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)
        button.setTitle("가입 완료", for: .normal)
        button.layer.cornerRadius = 9
        
        return button
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.toastMessage = ToastMessageView(superView: self.view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        bottomLayer.frame = CGRect(x: 0, y: nicknameTextField.frame.size.height + 4, width: nicknameTextField.frame.width, height: 1)
        nicknameTextField.layer.addSublayer(bottomLayer)
    }
    
    deinit {
        debugPrint("DEINIT - LoginNickNameViewController")
    }
    
    private func bind() {
        viewModel.isNicknameValid
            .subscribe(onNext: { [weak self] emit in
                self?.errorLabel.text = emit.description
                self?.configureUI(isError: emit.isError)
            })
            .disposed(by: disposeBag)
        
        viewModel.changeProfileImage
            .subscribe { [weak self] data in
                guard let data = data else { return }
                
                self?.profileImageView.image = UIImage(data: data)
            }
            .disposed(by: disposeBag)
        
        viewModel.dismissForNext
            .subscribe { [weak self] in
                if $0.isError {
                    self?.toastMessage?.presentStandardToastMessage("닉네임 등록을 완료해주세요")
                } else {
                    DispatchQueue.main.async {
                        let tabBarController = MainTabbarController()
                        
                        self?.navigationController?.isNavigationBarHidden = true
                        self?.navigationController?.pushViewController(tabBarController, animated: true)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func configureUI(isError: Bool) {
        self.bottomLayer.backgroundColor = isError ? UIColor.red.cgColor : UIColor.black.cgColor
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
        viewModel.tapRegisterButton.onNext(())
    }
    
    private func configureTargetAction() {
        registButton.addTarget(self, action: #selector(tapRegistButton), for: .touchUpInside)
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapImage))
        profileImageView.addGestureRecognizer(gesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc
    private func tapImage() {
        let customPhotoAlbumViewController = CustomPhotoAlbumViewController(maxSelect: 1)
        customPhotoAlbumViewController.modalPresentationStyle = .fullScreen
        
        self.present(customPhotoAlbumViewController, animated: true)
        
        //TODO: 이미지 변환할 때 까지 Button 비활성화 (비동기에 의한 데이터 변환 딜레이 대비)
        customPhotoAlbumViewController.completionHandlerChangePHAssetsToDatas = { [weak self] in
            guard let asset = $0.first else { return }
            
            PHImageManager().requestImageDataAndOrientation(for: asset, options: nil) { data, _, _, _ in
                self?.viewModel.profileImage.onNext(data)
            }
        }
    }
}

//MARK: -Layout Configure
extension LoginNickNameViewController {
    
    private func configureLayout() {
        
        [titleLabel, profileImageView, bodyLabel, nicknameTextField, errorLabel, registButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            bodyLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            nicknameTextField.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            registButton.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 121),
            
            profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            
            bodyLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 24),
            
            nicknameTextField.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 16),
            
            errorLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 4),
            
            registButton.heightAnchor.constraint(equalToConstant: 55),
            registButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 24),
            registButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -24),
            registButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -43)
        ])
    }
}
