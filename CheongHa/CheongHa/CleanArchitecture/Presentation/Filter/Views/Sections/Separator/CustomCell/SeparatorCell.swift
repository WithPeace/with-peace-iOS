//
//  SeparatorCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/21/24.
//

import UIKit
import FlexLayout

final class SeparatorCell: BaseCollectionViewCell {
    
    private let separatorView = SeparatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        flexContainerView.flex.define {
            $0.addItem(separatorView).width(100%).height(1)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
