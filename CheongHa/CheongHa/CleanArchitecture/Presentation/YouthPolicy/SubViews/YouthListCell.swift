//
//  YouthListCell.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/8/24.
//

import UIKit

final class YouthListCell: UICollectionViewCell {
    
//    static let identifier = "YouthListCell"
    
    private let labelContentsView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 1
        label.textColor = .label
        label.font = .boldSystemFont(ofSize: 16)
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.textColor = .label
        label.font = .systemFont(ofSize: 12)
        
        return label
    }()
    
    private let regionLabel: UILabel = {
        let label = BasePaddingLabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)
        label.backgroundColor = UIColor(named: Const.CustomColor.BrandColor2.subPurple)
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        
        return label
    }()
    
    private let ageLabel: UILabel = {
        let label = BasePaddingLabel()
        
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor(named: Const.CustomColor.SystemColor.black)
        label.backgroundColor = UIColor(named: Const.CustomColor.SystemColor.gray3)
        
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 5
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        
        self.contentView.backgroundColor = .systemBackground
        self.contentView.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2.0)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, 
                                        cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor

        contentView.layer.masksToBounds = true
        layer.cornerRadius = 10
    }
    
//    override func prepareForReuse() {
//    }
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        
        [labelContentsView, imageView].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        [titleLabel, bodyLabel, regionLabel, ageLabel].forEach {
            self.labelContentsView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let screenWidth = UIScreen.main.bounds.width - 48
        
        NSLayoutConstraint.activate([
            labelContentsView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            labelContentsView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            labelContentsView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16),
            labelContentsView.widthAnchor.constraint(equalToConstant: screenWidth * 230/327),
            
            imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
//            imageView.widthAnchor.constraint(equalToConstant: screenWidth * 57/327),
            imageView.widthAnchor.constraint(equalToConstant: 57),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: labelContentsView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: labelContentsView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: labelContentsView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            regionLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8),
            regionLabel.leadingAnchor.constraint(equalTo: labelContentsView.leadingAnchor),
            regionLabel.bottomAnchor.constraint(equalTo: labelContentsView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: regionLabel.topAnchor),
            ageLabel.leadingAnchor.constraint(equalTo: regionLabel.trailingAnchor, constant: 8),
            ageLabel.bottomAnchor.constraint(equalTo: regionLabel.bottomAnchor)
        ])
    }
    
    func setTitleLabel(_ label: String) {
        self.titleLabel.text = label
    }
    
    func setBodyLabel(_ label: String) {
        self.bodyLabel.text = label
    }
    
    func setRegionLabel(_ label: String) {
        self.regionLabel.text = label
    }
    
    func setAgeLagel(_ label: String) {
        self.ageLabel.text = label
    }
    
    func setImageView(image: UIImage) {
        self.imageView.image = image
    }
}




final class BasePaddingLabel: UILabel {
    
    private var padding = UIEdgeInsets(top: 4.0, left: 8.0, bottom: 4.0, right: 8.0)
    
    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
//        self.layer.masksToBounds = true
//        self.layer.cornerRadius = 5
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    //안의 내재되어있는 콘텐트의 사이즈에 따라 height와 width에 padding값을 더해줌
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        
        return contentSize
    }
}
