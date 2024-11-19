//
//  CommunityCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/12/24.
//

import UIKit

final class CommunityCollectionViewCell: UICollectionViewCell {
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .gray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: HomeSectionItemDataCollection.CommunityData) {
//        print("CommunityData", data)
    }
}
