//
//  PostDTO.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/25/24.
//

import Foundation

struct PostDTO: DTOType {
    var data: [PostData]?
    var error: Errors?
}

struct PostData: Codable {
    let postId: Int
    let title: String
    let content: String
    let type: PostType
    let commentCount: Int
    let createDate: String
    let postImageUrl: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postId = try container.decode(Int.self, forKey: .postId)
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
        let type = try container.decode(String.self, forKey: .type)
        self.type = PostType(rawValue: type) ?? .freedom
        self.commentCount = try container.decode(Int.self, forKey: .commentCount)
        self.createDate = try container.decode(String.self, forKey: .createDate)
        self.postImageUrl = try container.decode(String.self, forKey: .postImageUrl)
    }
}
