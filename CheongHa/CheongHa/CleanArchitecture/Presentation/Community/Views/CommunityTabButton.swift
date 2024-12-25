//
//  CommunityTabButton.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/21/24.
//

import UIKit
import PinLayout

final class CommunityTabButton: UIView {
    
    let categoryIconView = UIImageView()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray2
        label.font = .systemFont(ofSize: 10)
        return label
    }()
    
    init(category: CommunityCategory) {
        super.init(frame: .zero)
        
        self.flex.define { flex in
            flex.addItem(categoryIconView).size(28).margin(6)
            flex.addItem(categoryLabel).marginHorizontal(11)
        }
        .direction(.column).justifyContent(.center).alignItems(.center)
        
        categoryIconView.image = UIImage(resource: category.iconNotSelectedImage)
        categoryLabel.text = category.categoryName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.flex.layout()
    }
}
