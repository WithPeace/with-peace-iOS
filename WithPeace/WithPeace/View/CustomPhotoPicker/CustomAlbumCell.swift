//
//  CustomAlbumCell.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/18/24.
//

import UIKit

final class CustomAlbumCell: UICollectionViewCell {
    
    static let identifier = "CustomPhotoAlbumView"
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: Const.Logo.MainLogo.withpeaceLogo)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let albumLabel: UILabel = {
        let label = UILabel()
        
        label.text = "앨범사진"
        label.textColor = .white
        
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        
        label.text = "12345"
        label.textColor = .white
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        
        [albumImageView, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        [albumLabel, countLabel].forEach(stackView.addArrangedSubview(_:))
        
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: self.topAnchor),
            albumImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            albumImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            albumImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: albumImageView.leadingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: albumImageView.bottomAnchor, constant: -10),
        ])
    }
    
    func setup(image: UIImage) {
        self.albumImageView.image = image
    }
    
    func setup(title: String) {
        self.albumLabel.text = String(title)
    }
    
    func setup(count: Int) {
        self.countLabel.text = String(count)
    }
}
