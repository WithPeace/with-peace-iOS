//
//  ProfileAccountView.swift
//  WithPeace
//
//  Created by Dylan_Y on 4/2/24.
//

import UIKit

final class ProfileAccountView: UIView {
    
    private let accountLabel: UILabel = {
        let label = UILabel()
        
        label.text = "계정"
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: Const.CustomColor.SystemColor.gray2)
        
        return label
    }()
    
    private let connectedAccountLabel:  UILabel = {
        let label = UILabel()
        
        label.text = "연결된 계정"
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    private let emailLabel:  UILabel = {
        let label = UILabel()
        
        label.text = "withpeace@withpeace.com"
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor(named: Const.CustomColor.SystemColor.gray2)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        [accountLabel, connectedAccountLabel, emailLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        let safe = self.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            accountLabel.topAnchor.constraint(equalTo: safe.topAnchor),
            accountLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            
            connectedAccountLabel.topAnchor.constraint(equalTo: accountLabel.bottomAnchor,
                                                       constant: 16),
            connectedAccountLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            connectedAccountLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor),
            
            emailLabel.centerYAnchor.constraint(equalTo: connectedAccountLabel.centerYAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: safe.trailingAnchor)
//            emailLabel.bottomAnchor.constraint(equalTo: safe.bottomAnchor)
        ])
    }
    
    func setEmailTitle(_ text: String) {
        DispatchQueue.main.async {
            self.emailLabel.text = text
        }
    }
}
