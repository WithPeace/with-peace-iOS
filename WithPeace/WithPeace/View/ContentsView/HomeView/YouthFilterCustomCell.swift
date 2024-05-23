//
//  YouthFilterCustomCell.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/22/24.
//

import UIKit

final class CustomCell: UITableViewCell {
    
    static let id = "CustomCell"
    
    private let title: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let checkBoxButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        //TODO: 이미지 변경
        button.setImage(UIImage(systemName: "apple.logo"), for: .normal)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        contentView.addSubview(title)
        contentView.addSubview(checkBoxButton)
        
        contentView.layoutMargins = .init(top: 0, left: 24, bottom: 0, right: 24)
        let margin = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor),
            title.leadingAnchor.constraint(equalTo: margin.leadingAnchor),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            checkBoxButton.topAnchor.constraint(equalTo: title.topAnchor),
            checkBoxButton.leadingAnchor.constraint(equalTo: title.trailingAnchor),
            checkBoxButton.trailingAnchor.constraint(equalTo: margin.trailingAnchor),
            checkBoxButton.bottomAnchor.constraint(equalTo: title.bottomAnchor),
            checkBoxButton.heightAnchor.constraint(lessThanOrEqualTo: title.heightAnchor),
            checkBoxButton.widthAnchor.constraint(equalTo: checkBoxButton.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // TODO: image변경
    func changeContents(title: String, isClicked: Bool) {
        self.title.text = title
        //TODO: 이미지 변경
        isClicked ? self.checkBoxButton.setImage(UIImage(systemName: "apple.logo"), for: .normal) : self.checkBoxButton.setImage(UIImage(systemName: "checkmark"), for: .normal)
    }
}
