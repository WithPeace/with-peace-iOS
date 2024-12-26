//
//  CommentNumberContainerView.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CommentNumberContainerView: UIView {
    
    private let commentIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .icComment)
        return imageView
    }()
    
    let commentNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "2"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        [
            commentIconImageView,
            commentNumberLabel
        ].forEach { addSubview($0) }
        
        commentIconImageView.snp.makeConstraints {
            $0.width.equalTo(14)
            $0.height.equalTo(13)
            $0.verticalEdges.leading.equalToSuperview()
        }
        
        commentNumberLabel.snp.makeConstraints {
            $0.leading.equalTo(commentIconImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(commentIconImageView)
            $0.trailing.equalToSuperview()
        }
    }
}
