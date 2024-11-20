//
//  BaseCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/20/24.
//

import UIKit
import PinLayout
import FlexLayout

class BaseCollectionViewCell: UICollectionViewCell {
    
    let flexContainerView = UIView()
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
                
        contentView.addSubview(flexContainerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainerView.pin.all()
        flexContainerView.flex.layout()
    }
}
