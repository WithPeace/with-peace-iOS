//
//  TitleCell.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit
import RxSwift

final class TitleCell: UITableViewCell {
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "제목을 입력하세요"
        
        return textField
    }()
    
    var textChanged: PublishSubject<String> = PublishSubject()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleCell()
        titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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
     
    @objc func textFieldDidChange(_ textField: UITextField) {
        textChanged.onNext(textField.text ?? "")
    }
}
