//
//  MyKeywordsHeader.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/18/24.
//

import UIKit
import PinLayout
import FlexLayout

final class MyKeywordsHeader: BaseCollectionViewCell {
    
    let myKeywordsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "관심 키워드"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    let tipInfoButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "exclamationmark.circle.fill")?.withTintColor(.gray2, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        flexContainerView.flex.define {
            $0.addItem(myKeywordsTitleLabel).maxHeight(17)
            $0.addItem(UIView()).width(4)
            $0.addItem(tipInfoButton).width(17).aspectRatio(1)
        }
        .direction(.row)
        .alignItems(.end)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
