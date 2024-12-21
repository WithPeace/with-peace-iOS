//
//  CommunityPostCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/20/24.
//

import UIKit
import PinLayout
import FlexLayout

final class CommunityPostCollectionViewCell: BaseCollectionViewCell {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "게시글 제목입니다"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let contentsLabel: UILabel = {
        let label = UILabel()
        label.text = "2줄 이상 게시글 내용입니다. 2줄 이상 게시글 내용입니다. 2줄 이상 게시글 내용입니다.2줄 이상 게시글 내용입니다.2줄 이상 게시글 내용입니다."
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private let commentIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .icComment).withRenderingMode(.alwaysOriginal)
        return imageView
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private let separatorLabel: UILabel = {
        let label = UILabel()
        label.text = " | "
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "30초 전"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 10, weight: .regular)
        return label
    }()
    
    private let thumnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .cultureThumbnail)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        flexContainerView.layer.cornerRadius = 10
        flexContainerView.clipsToBounds = true
        flexContainerView.layer.borderWidth = 1
        flexContainerView.layer.borderColor = UIColor.gray2.cgColor
        
        flexContainerView.flex.define { flex in
            flex.addItem().direction(.row).define { flex in
                flex.addItem().direction(.column).define { flex in
                    flex.addItem(titleLabel)
                    flex.addItem(contentsLabel)
                    flex.addItem().direction(.row).define { flex in
                        flex.addItem(commentIconImageView).width(8).height(7).marginRight(2)
                        flex.addItem(commentCountLabel)
                        flex.addItem(separatorLabel)
                        flex.addItem(timeLabel)
                    }.alignItems(.center)
                }.justifyContent(.spaceBetween).maxWidth(72%)
                flex.addItem().direction(.column).define { flex in
                    flex.addItem(thumnailImageView).width(72).aspectRatio(1)
                }.justifyContent(.center).height(100%)
            }
            .justifyContent(.spaceBetween).height(100%).padding(16)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
