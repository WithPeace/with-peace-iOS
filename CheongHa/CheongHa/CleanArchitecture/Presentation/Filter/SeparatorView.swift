//
//  SeparatorView.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/23/24.
//

import UIKit

final class SeparatorView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .gray3
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
