//
//  CommentSectionCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/22/24.
//

import UIKit
import FlexLayout
import Kingfisher
import SnapKit

final class CommentUserProfileView: UIView {
    
    private let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        let imageURL = URL(string: "https://i.namu.wiki/i/d1A_wD4kuLHmOOFqJdVlOXVt1TWA9NfNt_HA0CS0Y_N0zayUAX8olMuv7odG2FiDLDQZIRBqbPQwBSArXfEJlQ.webp")
        imageView.kf.setImage(with: imageURL)
        
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글닉네임"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let timeLabel: UILabel = {
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

final class CommentSectionCell: UICollectionViewCell {
    
    private let profileView = CommentUserProfileView()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(resource: .icMoreButton)
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "한 평화로운 아침, 작은 마을에는 평화로운 분위기가로운 아침, 작은 마을에는 평화로운 분위기가로운 아침, 작은 마을에는 평화로운 분위기가로운 아침, 작은 마을에는 평화로운 분위기가로운 아침, 작은 마을에는 평화로운 분위기가로운 아침, 작은 마을에는 평화로운 분위기가로운 아침, 작은 마을에는 평화로운 분위기가로운 아침, 작은 마을에는 평화로운 분위기가로운 아침, 작은 마을에는 평화로운 분위기가로운 아침, 작은 마을에는 평화로운 분위기가"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let separatorView = SeparatorView()
    
    private let containerView = UIView()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        [
            profileView,
            moreButton,
            contentLabel,
            separatorView
        ].forEach { containerView.addSubview($0) }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        profileView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.trailing.equalTo(moreButton).offset(8)
        }
        
        moreButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalTo(profileView.snp.centerY)
            $0.trailing.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(8)
            $0.leading.equalTo(profileView)
            $0.trailing.equalTo(moreButton)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(contentLabel.snp.bottom).offset(8)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}
