//
//  CategoryViewCell.swift
//  WithPeace
//
//  Created by Hemg on 3/19/24.
//

import UIKit

final class CategoryViewCell: UITableViewCell {
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let selectButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: Const.CustomIcon.ICBtnPostcreate.icSelect), for: .normal)
        
        return button
    }()
    
    var onButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCategoryCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupCategoryCell() {
        contentView.addSubview(categoryLabel)
        contentView.addSubview(selectButton)
        
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            selectButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            selectButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        selectButton.addTarget(self, action: #selector(didTapSelectButton), for: .touchUpInside)
    }
    
    func configure(_ category: String) {
        categoryLabel.text = category
    }
    
    @objc private func didTapSelectButton() {
        onButtonTapped?()
    }
}
