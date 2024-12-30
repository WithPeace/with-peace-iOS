//
//  PostTopicCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/28/24.
//

import UIKit
import SnapKit

final class PostTopicCell: UITableViewCell {
    
    private let topicLabel: UILabel = {
        let label = UILabel()
        label.text = "게시글의 주제를 선택해주세요"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let chevronButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(resource: .icSelect)
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    private let separatorView = SeparatorView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        [
            topicLabel,
            chevronButton,
            separatorView
        ].forEach { contentView.addSubview($0) }
        
        topicLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.leading.equalToSuperview()
        }
        
        chevronButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.centerY.equalTo(topicLabel)
            $0.trailing.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.equalTo(topicLabel.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

