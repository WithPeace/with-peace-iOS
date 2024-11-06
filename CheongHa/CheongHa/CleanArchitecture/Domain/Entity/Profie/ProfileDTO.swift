//
//  ProfileDTO.swift
//  WithPeace
//
//  Created by Dylan_Y on 6/17/24.
//

import Foundation

struct SearchDataDTO: Codable {
    var userId: Int
    var email: String
    var profileImageUrl: String //기본 Image의 경우 default.png
    var nickname: String
}
