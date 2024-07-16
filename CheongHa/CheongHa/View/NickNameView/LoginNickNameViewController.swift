//
//  LoginNickNameViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/14/24.
//

import UIKit
import RxSwift
import Photos

final class LoginNickNameViewController: UIViewController {
    
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
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: Const.CustomIcon.ICProfile.defualtProfile)
        
        return imageView
    }()
    
    private let editImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: Const.CustomIcon.ICProfile.icMypageEdit)
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        nicknameTextField.delegate = self
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
        viewModel.checkingDuplication
            .subscribe(onNext: { [weak self] emit in
                DispatchQueue.main.async {
                    self?.errorLabel.text = emit.description
                }
                self?.configureUI(isError: emit.isError)
            })
            .disposed(by: disposeBag)
        
        viewModel.isNicknameValid
            .subscribe(onNext: { [weak self] emit in
                DispatchQueue.main.async {
                    self?.errorLabel.text = emit.description
                }
                
                if emit == .empty {
                    self?.configureUI(isError: false)
                    return
                }
                
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
                if $0 != .success {
                    self?.toastMessage?.presentStandardToastMessage("닉네임 등록을 완료해주세요")
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.allSuccess
            .subscribe { [weak self] in
                if $0 {
                    DispatchQueue.main.async {
                        guard let app = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return }
                        app.changeViewController()
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
        customPhotoAlbumViewController.completionHandlerPHAssets = { [weak self] in
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
        
        view.addSubview(editImageView)
        NSLayoutConstraint.activate([
            editImageView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor,
                                                    constant: -6),
            editImageView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor,
                                                  constant: -6),
            editImageView.heightAnchor.constraint(equalToConstant: 26),
            editImageView.widthAnchor.constraint(equalToConstant: 26),
        ])
        
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

extension LoginNickNameViewController: UITextFieldDelegate {
    //MARK: -Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
