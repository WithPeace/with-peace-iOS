//
//  PostTitleCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/28/24.
//

import UIKit
import SnapKit

final class PostTitleCell: UITableViewCell {
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "제목을 입력해주세요"
        textField.font = .systemFont(ofSize: 18, weight: .medium)
//        textField.borderStyle = .none
        return textField
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
            titleTextField,
            separatorView
        ].forEach { contentView.addSubview($0) }
        
        titleTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalToSuperview().inset(16)
        }
        
        separatorView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
            $0.top.equalTo(titleTextField.snp.bottom).offset(16)
            $0.bottom.equalToSuperview()
        }
    }
}
