//
//  YouthDetailContentView.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/29/24.
//

import UIKit

final class YouthDetailContentView: UIView {
    
    private let contents: [(title: String, body: String)]
    
    private let separatorView: CustomProfileSeparatorView = {
        let separatorView = CustomProfileSeparatorView(colorName: Const.CustomColor.SystemColor.gray3)
        
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        return separatorView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.spacing = 16
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    init(contents: [(title: String, body: String)]) {
        self.contents = contents
        super.init(frame: .zero)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        for content in contents {
            let view: YouthDetailSubTitleView
            
            if isValidURL(content.body) {
                view = YouthDetailSubTitleView(isURL: true)
            } else {
                view = YouthDetailSubTitleView(isURL: false)
            }
            
            view.setTitle(content.title)
            view.setBody(content.body)
            
            bodyStackView.addArrangedSubview(view)
        }
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(separatorView)
        self.addSubview(titleLabel)
        self.addSubview(bodyStackView)
        
        self.layoutMargins = .init(top: 0, left: 24, bottom: 0, right: 24)
        let margin = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 4),
            separatorView.topAnchor.constraint(equalTo: self.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            bodyStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            bodyStackView.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            bodyStackView.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            bodyStackView.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        ])
    }
    
    private func isValidURL(_ urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            return url.scheme != nil && url.host != nil
        }
        return false
    }
    
    func setTitle(_ text: String) {
        self.titleLabel.text = text
    }
}
