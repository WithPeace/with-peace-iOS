//
//  CustomProfileSeparatorView.swift
//  WithPeace
//
//  Created by Dylan_Y on 4/2/24.
//

import UIKit

final class CustomProfileSeparatorView: UIView {
    
    init(colorName: String) {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor(named: colorName)
    }
    
    init(color: UIColor) {
        super.init(frame: .zero)
        
        self.backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
