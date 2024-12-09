//
//  SignAuthDTO.swift
//  WithPeace
//
//  Created by Hemg on 3/12/24.
//

import Foundation

struct SignAuthDTO: DTOType {
    let data: DataClass
    let error: Errors?
}

struct DataClass: Codable {
    let jwtTokenDto: JwtTokenDto?
    let accessToken, refreshToken: String?
    let role: Role?
}

struct JwtTokenDto: Codable {
    let accessToken: String
    let refreshToken: String
}
