//
//  CommentUserProfileView.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/26/24.
//

import UIKit
import Kingfisher
import SnapKit

final class CommentUserProfileView: UIView {
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글닉네임"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "3일전"
        label.textColor = .gray2
        label.font = .systemFont(ofSize: 12, weight: .regular)
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
            userProfileImageView,
            userNameLabel,
            timeLabel
        ].forEach { addSubview($0) }
        
        userProfileImageView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.leading.top.bottom.equalToSuperview()
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(userProfileImageView)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints {
            $0.bottom.equalTo(userProfileImageView)
            $0.leading.equalTo(userProfileImageView.snp.trailing).offset(8)
            $0.trailing.equalToSuperview()
        }
    }
}
