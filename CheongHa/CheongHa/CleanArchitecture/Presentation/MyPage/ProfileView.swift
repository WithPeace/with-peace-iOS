//
//  ProfileView.swift
//  WithPeace
//
//  Created by Dylan_Y on 4/2/24.
//

import UIKit

final class ProfileView: UIView {
    
    private var tapAction: (() -> Void) = {}
    
    private let profileImageView: UIImageView = {
        let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 54, height: 54))
        
        view.clipsToBounds = true
        view.layer.cornerRadius = 27
        view.contentMode = .scaleAspectFill
        view.image = UIImage(named: Const.Logo.MainLogo.cheonghaMainLogo)
        
        return view
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16)
        label.text = "NickNameNickName"
        
        return label
    }()
    
    private let profileSetupButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("프로필 수정", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(UIColor(named: Const.CustomColor.BrandColor2.mainPurple), for: .normal)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        configureButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        [profileImageView, nickNameLabel, profileSetupButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: safe.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 54),
            profileImageView.widthAnchor.constraint(equalToConstant: 54),
            
            nickNameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            nickNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor,
                                                   constant: 8),
            
            profileSetupButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            profileSetupButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor)
        ])
    }
    
    private func configureButtonAction() {
        self.profileSetupButton.addTarget(self, action: #selector(tapProfileSetupButton), for: .touchUpInside)
    }
    
    @objc
    private func tapProfileSetupButton() {
        tapAction()
    }
    
    func setup(image: UIImage) {
        DispatchQueue.main.async {
            self.profileImageView.image = image
        }
    }
    
    func setup(nickName: String) {
        DispatchQueue.main.async {
            self.nickNameLabel.text = nickName
        }
    }
    
    func setup(action: @escaping () -> Void) {
        self.tapAction = action
    }
}
