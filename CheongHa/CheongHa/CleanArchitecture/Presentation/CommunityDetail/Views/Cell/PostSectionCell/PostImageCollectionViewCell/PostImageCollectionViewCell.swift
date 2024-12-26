//
//  PostImageCollectionViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/22/24.
//

import UIKit
import Kingfisher
import PinLayout

final class PostImageCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        let imageURL = URL(string: "https://img.hankyung.com/photo/202209/01.31363897.1.jpg")
        imageView.kf.setImage(with: imageURL)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.pin.all()
    }
}
