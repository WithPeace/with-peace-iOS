//
//  PolicyDTO.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/19/24.
//

import Foundation

struct PolicyDTO: DTOType {
    var data: [PolicyData]?
    var error: Errors?
}

struct PolicyData: Codable {
    let id: String
    let title: String
    let introduce: String
    let classification: PolicyClassification
    let region: String
    let ageInfo: String
    let isFavorite: Bool
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.introduce = try container.decode(String.self, forKey: .introduce)
        let classification = try container.decode(String.self, forKey: .classification)
        self.classification = PolicyClassification(rawValue: classification) ?? PolicyClassification.etc
        self.region = try container.decode(String.self, forKey: .region)
        self.ageInfo = try container.decode(String.self, forKey: .ageInfo)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
    }
}
