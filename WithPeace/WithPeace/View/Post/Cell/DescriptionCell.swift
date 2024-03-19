//
//  DescriptionCell.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit

final class DescriptionCell: UITableViewCell {
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "내용을 입력해주세요"
        
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
        contentView.addSubview(descriptionTextField)
        
        NSLayoutConstraint.activate([
            descriptionTextField.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            descriptionTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24)
        ])
    }
}
