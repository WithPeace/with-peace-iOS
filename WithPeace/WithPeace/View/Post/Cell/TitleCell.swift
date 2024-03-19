//
//  TitleCell.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit

final class TitleCell: UITableViewCell {
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목을 입력하세요"
        
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupTitleCell() {
        contentView.addSubview(titleTextField)
        
        NSLayoutConstraint.activate([
            titleTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleTextField.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
