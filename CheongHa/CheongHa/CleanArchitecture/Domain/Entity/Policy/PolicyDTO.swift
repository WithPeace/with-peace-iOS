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
    let classification: String
    let region: String
    let ageInfo: String
    let isFavorite: Bool
}
