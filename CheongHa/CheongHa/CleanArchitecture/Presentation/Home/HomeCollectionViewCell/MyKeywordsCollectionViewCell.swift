//
//  MyKeywordsCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/12/24.
//

import UIKit
import SnapKit

final class MyKeywordsCollectionViewCell: UICollectionViewCell {
    
    let label1: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요"
        return label
    }()
    
    let label2: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요"
        return label
    }()
    
    let label3: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요"
        return label
    }()
    
    let label4: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요"
        return label
    }()
    
    let label5: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요"
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        
        [
            label1, label2, label3, label4, label5
        ].forEach { stackView.addArrangedSubview($0) }
       
        return stackView
    }()
        
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        backgroundColor = .blue
        
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(_ data: HomeSectionItemDataCollection.MyKeywordsData) {
        print("MyKeywordsData", data)
    }
}

