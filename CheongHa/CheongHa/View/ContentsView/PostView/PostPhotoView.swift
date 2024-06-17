//
//  PostPhotoView.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit

final class PostPhotoView: UIView {
    private let photoButton = UIButton()
    var onPhotoButtonTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupButton() {
        backgroundColor = .systemBackground
        addSubview(photoButton)
        photoButton.translatesAutoresizingMaskIntoConstraints = false
        photoButton.setImage(UIImage(named: Const.CustomIcon.ICBtnPostcreate.icCamera), for: .normal)
        photoButton.addTarget(self, action: #selector(didTapPhotoButton), for: .touchUpInside)

        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: Const.CustomIcon.ICBtnPostcreate.icCamera)
        config.title = "사진"
        config.baseForegroundColor = .black
        config.imagePadding = 8
        photoButton.configuration = config

        NSLayoutConstraint.activate([
            photoButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            photoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -43)
        ])
    }
    
    @objc private func didTapPhotoButton() {
        onPhotoButtonTapped?()
    }
}
