//
//  FetchPoliciesQuery.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/26/24.
//

import Foundation

struct FetchPoliciesQuery {
    let region: String?
    let classification: String?
    let pageIndex: Int
    let display: Int
    
    init(
        region: String? = nil,
        classification: String? = nil,
        pageIndex: Int,
        display: Int
    ) {
        self.region = region
        self.classification = classification
        self.pageIndex = pageIndex
        self.display = display
    }
}
