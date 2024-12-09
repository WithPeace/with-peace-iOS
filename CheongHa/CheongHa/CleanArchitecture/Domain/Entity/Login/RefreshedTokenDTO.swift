//
//  RefreshedTokenDTO.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/7/24.
//

import Foundation

struct RefreshedTokenDTO: DTOType {
    let data: RefreshedTokenData?
    let error: Errors?
}

struct RefreshedTokenData: Codable {
    let accessToken: String
    let refreshToken: String
}
