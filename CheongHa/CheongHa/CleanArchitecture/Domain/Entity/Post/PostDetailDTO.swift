//
//  PostDetailDTO.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/25/24.
//

import Foundation

struct PostDetailDTO: DTOType {
    var data: [PostDetailData]?
    var error: Errors?
}

struct PostDetailData: Codable {
    let postId: Int
    let userId: Int
    let nickname: String
    let profileImageUrl: String
    let title: String
    let content: String
    let type: PostType
    let createDate: String
    let postImageUrls: [String]
    let comments: [CommentData]
}

struct CommentData: Codable {
    let commentId: Int
    let userId: Int
    let nickname: String
    let postImageUrls: String
    let content: String
    let createDate: String
}
