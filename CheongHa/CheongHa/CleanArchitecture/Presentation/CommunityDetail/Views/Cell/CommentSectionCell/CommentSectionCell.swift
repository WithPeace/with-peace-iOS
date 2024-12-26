//
//  CommentSectionCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/22/24.
//

import UIKit
import Kingfisher
import SnapKit

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
    
    func setData(_ data: CommunityDetailSectionDataCollection.CommentItemData) {
        let imageURL = URL(string: data.profileImageUrl)
        profileView.userProfileImageView.kf.setImage(with: imageURL)
        profileView.timeLabel.text = data.createDate.convertToTimeAgoDate.timeAgoToDisplay
        profileView.userNameLabel.text = data.nickname
        
        contentLabel.text = data.content
    }
}
