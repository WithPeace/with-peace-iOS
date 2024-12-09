//
//  CurrentPolicyFiltering.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/28/24.
//

import Foundation

struct CurrentPolicyFiltering: DTOType {
    let data: CurrentPolicyFilteringData?
    let error: Errors?
}

struct CurrentPolicyFilteringData: Codable {
    let region: [String]
    let classification: [PolicyClassification]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.region = try container.decode([String].self, forKey: .region)
        let classification = try container.decode([String].self, forKey: .classification)
        self.classification = classification.map { PolicyClassification(rawValue: $0) ?? PolicyClassification.etc }
    }
}
