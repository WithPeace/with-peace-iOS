//
//  DescriptionCell.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit
import RxSwift

final class DescriptionCell: UITableViewCell {
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "내용을 입력해주세요"
        
        return textField
    }()
    
    var textChanged: PublishSubject<String> = PublishSubject()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleCell()
        descriptionTextField.addTarget(self, action: #selector(textViewDidChange(_:)), for: .editingChanged)
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
    
    @objc func textViewDidChange(_ textField: UITextField) {
        textChanged.onNext(textField.text ?? "")
    }
}
