//
//  CommunityRegistrationBottomContainerView.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/30/24.
//

import UIKit
import PinLayout
import FlexLayout

final class CommunityRegistrationBottomContainerView: UIView {
    
    private let cameraImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .icCamera)
        return imageView
    }()
    
    private let photoLabel: UILabel = {
        let label = UILabel()
        label.text = "사진"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.flex.direction(.row).define { flex in
            flex.addItem(cameraImageView).size(24)
            flex.addItem(photoLabel).marginLeft(8)
        }.alignItems(.center)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
