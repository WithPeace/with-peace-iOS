//
//  HotPolicyCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/12/24.
//

import UIKit

final class HotPolicyCollectionViewCell: UICollectionViewCell {
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .yellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: HomeSectionItemDataCollection.HotPolicyData) {
        print("HotPolicyData", data)
    }
}
