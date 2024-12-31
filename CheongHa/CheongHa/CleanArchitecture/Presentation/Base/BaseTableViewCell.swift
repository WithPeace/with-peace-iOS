//
//  BaseTableViewCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/28/24.
//

import UIKit
import PinLayout
import FlexLayout

class BaseTableViewCell: UITableViewCell {
    
    let flexContainerView = UIView()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(flexContainerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flexContainerView.pin.all()
        flexContainerView.flex.layout()
    }
}
