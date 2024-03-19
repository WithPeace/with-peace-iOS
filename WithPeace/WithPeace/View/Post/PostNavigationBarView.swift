//
//  PostNavigationBarView.swift
//  WithPeace
//
//  Created by Hemg on 3/18/24.
//

import UIKit

final class PostNavigationBarView: UIView {
    private let customTitleLabel = UILabel()
    private let completeButton = UIButton()
    private let backButton = UIButton()
    
    var onCompleteButtonTapped: (() -> Void)?
    var onBackButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .systemBackground
        setupNavigationBackButton()
        setupNavigationBarLabel()
        setupNavigationBarButton()
    }
    
    private func setupNavigationBackButton() {
        addSubview(backButton)
        backButton.setImage(UIImage(named: Const.CustomIcon.ICBtnPostcreate.icSignBack), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupNavigationBarLabel() {
        customTitleLabel.text = "글 쓰기"
        addSubview(customTitleLabel)
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTitleLabel.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 24),
            customTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupNavigationBarButton() {
        addSubview(completeButton)
        completeButton.addTarget(self, action: #selector(didTapCompleteButton), for: .touchUpInside)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            completeButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func updateCompleteButton(isEnabled: Bool) {
        let buttonImage = isEnabled ? UIImage(named: Const.CustomIcon.ICBtnPostcreate.btnPostcreateDoneSelect) : UIImage(named: Const.CustomIcon.ICBtnPostcreate.btnPostcreateDone)
        completeButton.setImage(buttonImage, for: .normal)
        completeButton.isEnabled = isEnabled
    }
    
    @objc private func didTapBackButton() {
        onBackButtonTapped?()
    }
    
    @objc private func didTapCompleteButton() {
        onCompleteButtonTapped?()
    }
}
