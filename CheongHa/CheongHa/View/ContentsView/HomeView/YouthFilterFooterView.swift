//
//  YouthFilterFooterView.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/22/24.
//

import UIKit

final class YouthFilterFooterView: UIView {
    
    private let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        return imageView
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
        self.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func changeWill(isFold: Bool) {
        if isFold {
            titleLabel.text = "더보기"
            imageView.image = UIImage(named: Const.CustomIcon.ICExpansion.icMore)?.withTintColor(.label)
        } else {
            titleLabel.text = "접기"
            imageView.image = UIImage(named: Const.CustomIcon.ICExpansion.icLess)?.withTintColor(.label)
        }
    }
}
