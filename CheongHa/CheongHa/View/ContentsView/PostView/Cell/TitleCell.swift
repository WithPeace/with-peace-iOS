//
//  TitleCell.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit
import RxSwift

final class TitleCell: UITableViewCell, UITextViewDelegate {
    private lazy var titleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.isScrollEnabled = false
        textView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 4)
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }()
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "제목을 입력하세요"
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var textChanged: PublishSubject<String> = PublishSubject()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupTitleCell() {
        contentView.addSubview(titleTextView)
        titleTextView.addSubview(placeholderLabel)
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            titleTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            titleTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            placeholderLabel.leadingAnchor.constraint(equalTo: titleTextView.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: titleTextView.trailingAnchor, constant: -4),
            placeholderLabel.centerYAnchor.constraint(equalTo: titleTextView.centerYAnchor)
        ])
        
        updatePlaceholderVisibility()
    }
     
    func textViewDidChange(_ textView: UITextView) {
        textChanged.onNext(textView.text)
        updatePlaceholderVisibility()
    }
    
    func configureWithPostModel(_ model: PostModel) {
        titleTextView.text = model.title
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !titleTextView.text.isEmpty
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: KeyboardAction
extension TitleCell {
    
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
        titleTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        titleTextView.scrollIndicatorInsets = titleTextView.contentInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        titleTextView.contentInset = .zero
        titleTextView.scrollIndicatorInsets = .zero
    }
}
