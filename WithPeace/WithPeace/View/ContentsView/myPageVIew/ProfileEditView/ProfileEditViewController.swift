//
//  ProfileEditViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 4/17/24.
//

import UIKit
import RxSwift
import Photos

final class ProfileEditViewController: UIViewController {
    
    private let viewModel: ProfileEditViewModel
    private let disposeBag = DisposeBag()
    private let bottomLayer = CALayer()
    
    lazy private var toastMessage = ToastMessageView(superView: self.view, hasTabbar: true)
    
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
        button.setTitle("수정 완료", for: .normal)
        button.layer.cornerRadius = 9
        
        return button
    }()
    
    init(defaultNickname: String, defaultImageData: Data?) {
        viewModel = ProfileEditViewModel(existingNickname: defaultNickname,
                                         defaultImageData: defaultImageData)
        super.init(nibName: nil, bundle: nil)
        
        if let defaultImageData = defaultImageData {
            viewModel.tapProfileImage.onNext(defaultImageData)
        }
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
        
        //TODO: -CustomNavigationBar 변경
        navigationController?.navigationItem.titleView = CustomNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bottomLayer.removeFromSuperlayer()
        
        bottomLayer.frame = CGRect(x: 0,
                                   y: nicknameTextField.frame.size.height + 4,
                                   width: nicknameTextField.frame.width,
                                   height: 1)
        nicknameTextField.layer.addSublayer(bottomLayer)
    }
    
    deinit {
        debugPrint("DEINIT - LoginNickNameViewController")
    }
    
    private func bind() {
        self.viewModel.isValidNickName.subscribe { [weak self] state in
            DispatchQueue.main.async {
                self?.configureUI(isError: state.isErrorColor)
                self?.errorLabel.text = state.description
            }
        }.disposed(by: disposeBag)
        
        self.viewModel.profileImage
            .subscribe { image in
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
            .disposed(by: disposeBag)
        
        self.viewModel.toastmessage
            .subscribe { [weak self] toastText in
                self?.toastMessage.presentStandardToastMessage(toastText)
            }
            .disposed(by: disposeBag)
        
        self.viewModel.differentBefore
            .subscribe { bool in
                switch bool {
                case true:
                    let alert = CustomAlertSheetViewController(body: "수정사항이 있습니다. \n저장하시겠습니까?",
                                                        leftButtonTitle: "나가기",
                                                        leftButtonAction: self.tapLeftButton,
                                                        rightButtonTitle: "저장하기",
                                                        rightButtonAction: self.tapRightButton)
                    alert.modalPresentationStyle = .overFullScreen
                    alert.modalTransitionStyle = .crossDissolve
                    self.present(alert, animated: true)
                case false:
                    break
                }
            }
            .disposed(by: disposeBag)
        
        self.viewModel.allSuccess
            .subscribe { [weak self] in
                print("herherherherh : " , $0)
                if $0 == true {
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                    
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func configureUI(isError: Bool) {
        self.bottomLayer.backgroundColor = isError ? UIColor.red.cgColor : UIColor.black.cgColor
    }
    
    private func tapLeftButton() {
        viewModel.tapAlertLeftButton.onNext(())
    }
    
    private func tapRightButton() {
        viewModel.tapAlertRightButton.onNext(())
    }
}

//MARK: -objc Method
extension ProfileEditViewController {
    
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
                self?.viewModel.tapProfileImage.onNext(data)
            }
        }
    }
}

//MARK: -Keyboard
extension ProfileEditViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: -Layout Configure
extension ProfileEditViewController {
    
    private func configureLayout() {
        
        [profileImageView, bodyLabel, nicknameTextField, errorLabel, registButton].forEach {
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
            profileImageView.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            bodyLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            nicknameTextField.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            registButton.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 16),
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

//TODO: -CustomNavigationBar Setting
final class CustomNavigationBar: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "마이페이지"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            self.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
