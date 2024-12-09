//
//  PolicyRecommendationHeader.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/12/24.
//

import UIKit

final class PolicyRecommendationHeader: BaseHomeFilterCollectionViewHeader {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureLabel() {
        super.configureLabel()
        
        label.text = "{ID}님을 위한 맞춤 정책을 추천해드릴게요!"
    }
}
