//
//  MyKeywordsCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyKeywordsCollectionViewCell: UICollectionViewCell {
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.backgroundColor = .blue
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tagLabel)
        contentView.backgroundColor = .gray
        
        setConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConstraint() {
        tagLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(6)
            $0.leading.trailing.equalToSuperview().inset(8)
        }
    }

    func setData(_ data: String) {
//        print("MyKeywordsData", data)
        tagLabel.text = data
    }
}
