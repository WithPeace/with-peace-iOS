//
//  AlbumDetailCell.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/20/24.
//

import UIKit

final class AlbumDetailCell: UICollectionViewCell {
    
    static let identifier = "AlbumDetailCell"
    
    private var isSelectedCell = false
    
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: Const.withpeaceLogo)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    
    private let maskedCellView: UIImageView = {
        let view = UIImageView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: Const.CustomIcon.ICCell.icPictureSelect)
        view.isHidden = true
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        
        [albumImageView, maskedCellView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: self.topAnchor),
            albumImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            albumImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            albumImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            maskedCellView.centerXAnchor.constraint(equalTo: albumImageView.centerXAnchor),
            maskedCellView.centerYAnchor.constraint(equalTo: albumImageView.centerYAnchor)
        ])
    }
    
    func setup(image: UIImage) {
        self.albumImageView.image = image
    }
    
    func selectCell() {
        maskedCellView.isHidden = false
        albumImageView.alpha = 0.5
    }
    
    func deselectCell() {
        maskedCellView.isHidden = true
        albumImageView.alpha = 1
    }
}
