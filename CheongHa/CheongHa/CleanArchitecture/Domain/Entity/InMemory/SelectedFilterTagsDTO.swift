//
//  SelectedFilterTagsDTO.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/8/24.
//

import Foundation

struct SelectedFilterTagsDTO: Codable {
    let region: [String]
    let classification: [String]
    
    init(
        region: [String],
        classification: [String]
    ) {
        self.region = region
        self.classification = classification
    }
}
