//
//  MyKeywordsBackgroundView.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/20/24.
//

import UIKit
import SnapKit

final class MyKeywordsBackgroundView: BaseCollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
                
        flexContainerView.backgroundColor = .gray3
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
