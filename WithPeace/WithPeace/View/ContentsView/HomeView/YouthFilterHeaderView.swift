//
//  YouthFilterHeaderView.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/22/24.
//

import UIKit

final class YouthFilterHeaderView: UIView {
    
    private let seperatorView = CustomProfileSeparatorView(colorName: Const.CustomColor.SystemColor.gray3)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(seperatorView)
        self.addSubview(titleLabel)
        
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        layoutMargins = .init(top: 0, left: 24, bottom: 0, right: 24)
        let margin = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            seperatorView.topAnchor.constraint(equalTo: margin.topAnchor),
            seperatorView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: seperatorView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor)
        ])
    }
    
    func change(title label: String) {
        titleLabel.text = label
    }
}
