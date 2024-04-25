//
//  ForumModel.swift
//  WithPeace
//
//  Created by Hemg on 4/26/24.
//


struct PostListResponse: Codable {
    let data: [PostListModel]
    let error: String?
}

struct PostListModel: Codable {
    let postId: Int
    let title: String
    let content: String
    let type: String
    let createDate: String
    let postImageUrl: String?

    enum CodingKeys: String, CodingKey {
        case postId, title, content, type, createDate, postImageUrl
    }
}
