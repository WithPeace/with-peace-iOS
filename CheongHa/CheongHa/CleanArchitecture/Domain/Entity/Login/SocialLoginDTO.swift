//
//  SocialLoginDTO.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/6/24.
//

import Foundation

struct SocialLoginDTO: DTOType {
    let data: SocialLoginData?
    let error: Errors?
}

struct SocialLoginData: Codable {
    let jwtTokenDto: Tokens
    let role: Role?
}

struct Tokens: Codable {
    let accessToken: String
    let refreshToken: String
}

enum Role: String, Codable {
    case guest = "GUEST"
    case user = "USER"
}
