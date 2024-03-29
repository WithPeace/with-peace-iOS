//
//  CustomAlertSheetView.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/28/24.
//

import UIKit

class CustomAlertSheetView: UIView {
    
    private let isTitleUsing: Bool
    
    var leftAction: (() -> Void) = {}
    var rightAction: (() -> Void) = {}
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 18)
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16)
        
        return label
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton()
                
        button.layer.cornerRadius = 10
        button.backgroundColor = .white
        button.contentHorizontalAlignment = .center
        button.tintColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)
        button.setTitleColor(UIColor(named: Const.CustomColor.BrandColor2.mainPurple), for: .normal)

        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)?.cgColor
        
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton()
        
        button.contentHorizontalAlignment = .center
        button.backgroundColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 10
        
        return button
    }()
    
    init(title: String?,
         body: String,
         leftButtonTitle: String,
         rightButtonTitle: String
    ) {
        isTitleUsing = title == nil ? false : true
        
        super.init(frame: .zero)
        
        titleLabel.text = title
        bodyLabel.text = body
        leftButton.setTitle(leftButtonTitle, for: .normal)
        rightButton.setTitle(rightButtonTitle, for: .normal)
        
        title == nil ? configureLayoutOnlyBody() : configureLayoutWithTitle()
        setupBackGround()
        addActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBackGround() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 10
    }
    
    private func configureLayoutWithTitle() {
        [titleLabel, bodyLabel, leftButton, rightButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bodyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            leftButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 74),
            leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            rightButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 74),
            rightButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 8),
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            rightButton.widthAnchor.constraint(equalToConstant: 144),
            leftButton.widthAnchor.constraint(equalTo: rightButton.widthAnchor),
            
            rightButton.heightAnchor.constraint(equalToConstant: 40),
            leftButton.heightAnchor.constraint(equalTo: rightButton.heightAnchor)
        ])
    }
    
    private func configureLayoutOnlyBody() {
        [bodyLabel, leftButton, rightButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            bodyLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            leftButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 82),
            leftButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            rightButton.topAnchor.constraint(equalTo: leftButton.topAnchor),
            rightButton.leadingAnchor.constraint(equalTo: leftButton.trailingAnchor, constant: 8),
            rightButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            rightButton.widthAnchor.constraint(equalToConstant: 144),
            leftButton.widthAnchor.constraint(equalTo: rightButton.widthAnchor),
            
            rightButton.heightAnchor.constraint(equalToConstant: 40),
            leftButton.heightAnchor.constraint(equalTo: rightButton.heightAnchor)
        ])
    }
    
    private func addActions() {
        leftButton.addTarget(self, action: #selector(tapLeftButton), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(tapRightButton), for: .touchUpInside)
    }
    
    @objc
    private func tapLeftButton() {
        leftAction()
    }
    
    @objc
    private func tapRightButton() {
        rightAction()
    }
}
