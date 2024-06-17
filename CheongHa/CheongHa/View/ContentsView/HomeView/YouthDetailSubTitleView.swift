//
//  YouthDetailSubTitleView.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/30/24.
//

import UIKit

final class YouthDetailSubTitleView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyButton: UIButton = {
        let button = UIButton()
        
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    init(isURL: Bool) {
        super.init(frame: .zero)
        
        if isURL {
            bodyButton.addTarget(self, action: #selector(openSafari), for: .touchUpInside)
            configureLayoutWithButton()
        } else {
            configureLayoutWithLabel()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func openSafari() {
        guard let urlString = bodyButton.titleLabel?.text else { return }
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func configureLayoutWithLabel() {
        self.addSubview(titleLabel)
        self.addSubview(bodyLabel)
        
        self.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
        let margin = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        ])
    }
    
    private func configureLayoutWithButton() {
        self.addSubview(titleLabel)
        self.addSubview(bodyButton)
        
        self.layoutMargins = .init(top: 0, left: 0, bottom: 0, right: 0)
        let margin = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: margin.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            bodyButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyButton.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            bodyButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            bodyButton.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        ])
    }
    
    func setTitle(_ text: String) {
        self.titleLabel.text = text
    }
    
    func setBody(_ text: String) {
        self.bodyLabel.text = text
        self.bodyButton.setTitle(text, for: .normal)
    }
}
