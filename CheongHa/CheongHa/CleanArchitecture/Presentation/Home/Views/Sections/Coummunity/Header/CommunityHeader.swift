//
//  CommunityHeader.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/12/24.
//

import UIKit

final class CommunityHeader: BaseHomeCollectionViewHeader {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureLabel() {
        super.configureLabel()
        
        label.text = "커뮤니티"
    }
}
