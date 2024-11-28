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
    let classification: [String]
}
