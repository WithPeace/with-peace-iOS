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
    let type: PostType
    let postId: Int
    let title: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        self.type = PostType(rawValue: type) ?? PostType.freedom
        self.postId = try container.decode(Int.self, forKey: .postId)
        self.title = try container.decode(String.self, forKey: .title)
    }
}
