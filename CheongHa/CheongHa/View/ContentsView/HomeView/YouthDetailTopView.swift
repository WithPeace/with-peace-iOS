//
//  YouthDetailTopView.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/30/24.
//

import UIKit

final class YouthDetailTopView: UIView {
    
    private let separatorView: CustomSeparatorView = {
        let view = CustomSeparatorView(colorName: Const.CustomColor.SystemColor.gray3)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        self.addSubview(separatorView)
        self.addSubview(titleLabel)
        self.addSubview(bodyLabel)
        self.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: self.topAnchor),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            bodyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bodyLabel.heightAnchor.constraint(lessThanOrEqualTo: imageView.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: bodyLabel.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: bodyLabel.trailingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            
            bodyLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 254/57)
        ])
    }
    
    func setTitle(_ text: String) {
        titleLabel.text = text
    }
    
    func setBody(_ text: String) {
        bodyLabel.text = text
    }
    
    func setImage(_ image: UIImage?) {
        imageView.image = image
    }
    
    func calculateTitleHeight() -> Double {
        guard let labelWindowFrame = titleLabel.superview?.convert(titleLabel.frame, to: nil) else {
            return 0.0
        }
        return labelWindowFrame.height + titleLabel.frame.origin.y
    }
}
