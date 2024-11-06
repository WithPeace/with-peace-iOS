//
//  SignAuthDTO.swift
//  WithPeace
//
//  Created by Hemg on 3/12/24.
//

import Foundation

struct SignAuthDTO: Codable {
    let data: DataClass
    let error: Errors?
}

struct DataClass: Codable {
    let jwtTokenDto: JwtTokenDto?
    let accessToken, refreshToken: String?
    let role: Role?
}

struct JwtTokenDto: Codable {
    let accessToken, refreshToken: String
}

//TODO: RoleDetail "" ????
enum Role: String, Codable {
    case guest = "GUEST"
    case user = "USER"
}

struct Errors: Codable {
    var code: Int?
    var message: String?
}
