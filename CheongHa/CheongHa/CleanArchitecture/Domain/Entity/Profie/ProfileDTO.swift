//
//  ProfileDTO.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/7/24.
//

import Foundation

struct CleanProfileDTO: DTOType {
    var data: CleanProfileData?
    var error: Errors?
}

struct CleanProfileData: Codable {
    var userId: Int
    var email: String
    var profileImageUrl: String //기본 Image의 경우 default.png
    var nickname: String
}
