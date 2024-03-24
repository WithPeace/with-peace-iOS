//
//  DescriptionCell.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit
import RxSwift

final class DescriptionCell: UITableViewCell, UITextViewDelegate {
    private lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 4, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "내용을 입력해주세요"
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textChanged: PublishSubject<String> = PublishSubject()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleCell()
        setupNotification()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupTitleCell() {
        contentView.addSubview(descriptionTextView)
        descriptionTextView.addSubview(placeholderLabel)
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            descriptionTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            descriptionTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            placeholderLabel.topAnchor.constraint(equalTo: descriptionTextView.topAnchor),
            placeholderLabel.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor, constant: -4)
        ])
        
        updatePlaceholderVisibility()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textChanged.onNext(textView.text)
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !descriptionTextView.text.isEmpty
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: KeyboardAction
extension DescriptionCell {
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
                as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.size.height
        descriptionTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        descriptionTextView.scrollIndicatorInsets = descriptionTextView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        descriptionTextView.contentInset = .zero
        descriptionTextView.scrollIndicatorInsets = .zero
    }
}
