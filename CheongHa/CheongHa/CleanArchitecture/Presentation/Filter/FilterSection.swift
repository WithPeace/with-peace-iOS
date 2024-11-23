//
//  FilterSection.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/21/24.
//

import Foundation

enum FilterSection: Int, CaseIterable {
    case policyField
    case separator
    case region
}

struct FilterTagItem: Hashable {
    var title: String
    var isSelected: Bool
    
    init(
        title: String = "",
        isSelected: Bool = false
    ) {
        self.title = title
        self.isSelected = isSelected
    }
}
