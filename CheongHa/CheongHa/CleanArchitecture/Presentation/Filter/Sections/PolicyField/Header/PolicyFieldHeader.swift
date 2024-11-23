//
//  PolicyFieldHeader.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/21/24.
//

import UIKit

final class PolicyFieldHeader: BaseHomeFilterCollectionViewHeader {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureLabel() {
        super.configureLabel()
        
        label.text = "정책분야"
    }
}
