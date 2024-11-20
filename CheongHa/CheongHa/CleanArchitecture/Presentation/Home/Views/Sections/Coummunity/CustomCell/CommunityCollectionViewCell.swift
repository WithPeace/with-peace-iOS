//
//  CommunityCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/12/24.
//

import UIKit
import PinLayout
import FlexLayout

final class CommunityCollectionViewCell: BaseCollectionViewCell {
    
    let boardLabel: UILabel = {
        let label = UILabel()
        label.text = "자유게시판"
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .init(400))
        return label
    }()
    
    let postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "곧 SH 청년주택 신청기간입니다. 상세 정보입니다."
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray1
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
            
        flexContainerView.flex.define {
            $0.addItem(boardLabel)
            $0.addItem(UIView()).width(16)
            $0.addItem(postTitleLabel).shrink(1)
        }
        .direction(.row)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: HomeSectionItemDataCollection.CommunityData) {
//        print("CommunityData", data)
    }
}
