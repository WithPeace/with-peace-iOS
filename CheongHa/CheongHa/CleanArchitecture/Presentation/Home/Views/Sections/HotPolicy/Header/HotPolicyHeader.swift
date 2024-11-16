//
//  HotPolicyHeader.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/12/24.
//

import UIKit
import SnapKit

final class HotPolicyHeader: UICollectionReusableView {
    static let identifier = String(describing: HotPolicyHeader.self)
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.text = "안녕하세요."
        
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
