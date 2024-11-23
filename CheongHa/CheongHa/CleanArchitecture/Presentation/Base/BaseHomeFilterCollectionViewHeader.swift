//
//  BaseHomeFilterCollectionViewHeader.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/20/24.
//

import UIKit
import SnapKit

class BaseHomeFilterCollectionViewHeader: UICollectionReusableView {
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLabel()
        
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLabel() {
        label.font = .systemFont(ofSize: 18, weight: .bold)
    }
}
