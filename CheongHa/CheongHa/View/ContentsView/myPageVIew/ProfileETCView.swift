//
//  ProfileETCView.swift
//  WithPeace
//
//  Created by Dylan_Y on 4/2/24.
//

import UIKit

final class ProfileETCView: UIView {
    
    private var tapLogOutAction: () -> Void = {}
    private var tapSignOutAction: () -> Void = {}
    
    private let etcLabel: UILabel = {
        let label = UILabel()
        
        label.text = "기타"
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: Const.CustomColor.SystemColor.gray2)
        
        return label
    }()
    
    private let logOutButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("탈퇴하기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureLayout()
        configureButtonAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        [etcLabel, logOutButton, signOutButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            etcLabel.topAnchor.constraint(equalTo: safe.topAnchor),
            etcLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            
            logOutButton.topAnchor.constraint(equalTo: etcLabel.bottomAnchor, constant: 16),
            logOutButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            
            signOutButton.topAnchor.constraint(equalTo: logOutButton.bottomAnchor, constant: 16),
            signOutButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            signOutButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
        ])
    }
    
    private func configureButtonAction() {
        logOutButton.addTarget(self, action: #selector(tapLogOutButton), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(tapSignOutButton), for: .touchUpInside)
    }
    
    @objc
    private func tapLogOutButton() {
        tapLogOutAction()
    }
    
    @objc
    private func tapSignOutButton() {
        tapSignOutAction()
    }
    
    func setup(logOutAction: @escaping () -> Void) {
        self.tapLogOutAction = logOutAction
    }
    
    func setup(signOutAction: @escaping () -> Void) {
        self.tapSignOutAction = signOutAction
    }
}
