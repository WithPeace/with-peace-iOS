//
//  SelectPostTopicCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/30/24.
//

import UIKit
import FlexLayout

final class SelectPostTopicCollectionViewCell: BaseCollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .icFreeTagNotSelected)
        return imageView
    }()
    
    private let topicLabel: UILabel = {
        let label = UILabel()
        label.text = "자유"
        label.textColor = .gray2
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        flexContainerView.flex.direction(.column).define { flex in
            flex.addItem(imageView).size(56).marginBottom(8)
            flex.addItem(topicLabel)
        }.justifyContent(.center).alignItems(.center)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDatas(_ data: CommunityCategory) {
        imageView.image = UIImage(resource: data.iconNotSelectedImage)
        topicLabel.text = data.categoryName
    }
}
