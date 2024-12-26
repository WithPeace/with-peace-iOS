//
//  PostDetailDTO.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/25/24.
//

import Foundation

struct PostDetailDTO: DTOType {
    var data: PostDetailData?
    var error: Errors?
}

struct PostDetailData: Codable {
    let postId: Int
    let userId: Int
    let nickname: String
    let profileImageUrl: String?
    let title: String
    let content: String
    let type: PostType
    let createDate: String
    let postImageUrls: [String]
    let comments: [CommentData]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postId = try container.decode(Int.self, forKey: .postId)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl) ?? ""
        self.title = try container.decode(String.self, forKey: .title)
        self.content = try container.decode(String.self, forKey: .content)
        self.type = try container.decode(PostType.self, forKey: .type)
        self.createDate = try container.decode(String.self, forKey: .createDate)
        self.postImageUrls = try container.decode([String].self, forKey: .postImageUrls)
        self.comments = try container.decode([CommentData].self, forKey: .comments)
    }
}

struct CommentData: Codable {
    let commentId: Int
    let userId: Int
    let nickname: String
    let profileImageUrl: String?
    let content: String
    let createDate: String
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commentId = try container.decode(Int.self, forKey: .commentId)
        self.userId = try container.decode(Int.self, forKey: .userId)
        self.nickname = try container.decode(String.self, forKey: .nickname)
        self.profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl) ?? ""
        self.content = try container.decode(String.self, forKey: .content)
        self.createDate = try container.decode(String.self, forKey: .createDate)
    }
}
