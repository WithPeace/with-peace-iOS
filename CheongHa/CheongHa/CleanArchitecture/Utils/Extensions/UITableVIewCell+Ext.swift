//
//  UITableVIewCell+Ext.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/28/24.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
    
    static var kind: String {
        String(describing: self) + "kind"
    }
}
