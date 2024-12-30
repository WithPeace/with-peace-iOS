//
//  SelectedImagesCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/27/24.
//

import UIKit
import SnapKit

final class SelectedImageCell: BaseCollectionViewCell {
    
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .cultureThumbnail)
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(resource: .btnPictureDelete)
        button.setImage(buttonImage, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        [
            selectedImageView,
            closeButton
        ].forEach { contentView.addSubview($0) }
        
        selectedImageView.snp.makeConstraints {
            $0.size.equalTo(110)
            $0.leading.bottom.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.trailing.equalToSuperview()
        }
    }
}
