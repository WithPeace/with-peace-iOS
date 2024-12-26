//
//  PostUserProfileView.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PostUserProfileView: UIView {
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.cornerRadius = 28
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let infoContainerView = UIView()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임닉네임"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let postUploadTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "3일전"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        
        [
            userNameLabel,
            postUploadTimeLabel
        ].forEach { infoContainerView.addSubview($0) }
        
        userNameLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        postUploadTimeLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        [
            userProfileImageView,
            infoContainerView
        ].forEach { addSubview($0)}
        
        userProfileImageView.snp.makeConstraints {
            $0.size.equalTo(56)
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        infoContainerView.snp.makeConstraints {
            $0.centerY.equalTo(userProfileImageView)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
    }
}
