//
//  RegionCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RegionCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let tagLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer()
        contentView.addGestureRecognizer(tapGesture)
        return tapGesture
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(tagLabel)
        contentView.layer.cornerRadius = 18
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 1

        tagLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(8)
            $0.leading.trailing.equalToSuperview().inset(14)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }

    func setData(_ data: FilterTagItem) {
        tagLabel.text = data.title
        
        if data.isSelected {
            contentView.layer.borderColor = UIColor.mainPurple.cgColor
            contentView.backgroundColor = .mainPurple
            tagLabel.textColor = .white
        } else {
            contentView.layer.borderColor = UIColor.gray2.cgColor
            contentView.backgroundColor = .white
            tagLabel.textColor = .blackCustom
        }
    }
}
