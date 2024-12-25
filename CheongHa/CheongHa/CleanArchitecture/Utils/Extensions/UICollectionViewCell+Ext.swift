//
//  UICollectionViewCell+Ext.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/12/24.
//

import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        String(describing: self)
    }
    
    static var kind: String {
        String(describing: self) + "kind"
    }
}
