//
//  PostDTO.swift
//  WithPeace
//
//  Created by Dylan_Y on 6/17/24.
//

import Foundation

// Post Regist
struct PostDTOpostID: Codable {
    let postId: Int
}

// Post
struct PostDetailItem: Codable {
    let postId: Int
    let userId: Int
    let nickname: String
    let profileImageUrl: String
    let title: String
    let content: String
    let type: String
    let createDate: String
    let postImageUrls: [String]?
    let comments: [PostCommentItem]?
}

struct PostCommentItem: Codable {
    let commentId: Int
    let userId: Int
    let nickname: String
    let porfileImageUrl: String?
    let content: String
    let createDate: String
}

struct PostListItem: Codable {
    let postId: Int
    let title: String
    let content: String
    let type: String
    let commentCount: Int
    let createDate: String
    let postImageUrl: String?
}
