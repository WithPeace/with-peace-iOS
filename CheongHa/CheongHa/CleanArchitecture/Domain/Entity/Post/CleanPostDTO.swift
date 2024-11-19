//
//  CleanPostDTO.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/19/24.
//

import Foundation

struct CleanPostDTO: DTOType {
    var data: [PostData]?
    var error: Errors?
}

struct PostData: Codable {
    let type: String
    let postId: Int
    let title: String
}
