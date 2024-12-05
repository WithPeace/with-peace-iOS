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
    
    var disposeBag = DisposeBag()
    
    let filterButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "slider.horizontal.3")?.withTintColor(.mainPurple, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .mainPurple
        label.backgroundColor = .subPurple
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .subPurple
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    func setData(_ data: String) {
        if data == "filter" {
            tagLabel.removeFromSuperview()
            tagLabel.snp.removeConstraints()
            contentView.addSubview(filterButton)
            filterButton.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.width.height.equalTo(16)
                $0.edges.equalToSuperview().inset(4)
            }
            
            contentView.layer.cornerRadius = filterButton.frame.width / 2
        } else {
            filterButton.removeFromSuperview()
            filterButton.snp.removeConstraints()
            contentView.addSubview(tagLabel)
            tagLabel.text = "#\(data)"
            tagLabel.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(6)
                $0.leading.trailing.equalToSuperview().inset(8)
            }
            
            contentView.layer.cornerRadius = 7
        }
    }
}
