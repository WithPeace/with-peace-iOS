//
//  PolicyRecommendationCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/12/24.
//

import UIKit
import PinLayout
import FlexLayout

final class PolicyRecommendationCollectionViewCell: BaseCollectionViewCell {
        
    let policyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .jobThumbnail)
        return imageView
    }()
    
    let policyDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "울산대학교 대학일자리플러스센터(거점형)"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
                
        flexContainerView.flex.define {
            $0.addItem(policyImageView)
                .width(100%)
                .aspectRatio(1)
            
            $0.addItem(UIView()).height(8)
            
            $0.addItem(policyDescriptionLabel)
                .width(100%)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: HomeSectionItemDataCollection.PolicyRecommendationData) {
        policyImageView.image = UIImage(resource: data.thumnail)
        policyDescriptionLabel.text = data.description
    }
}
