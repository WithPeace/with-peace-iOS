//
//  PostDetailModel.swift
//  WithPeace
//
//  Created by Hemg on 5/5/24.
//

import Foundation

struct PostDetailResponse: Codable {
    let data: PostData
    let error: String?
}

struct PostData: Codable {
    let postId: Int
    let userId: Int
    let nickname: String
    let profileImageUrl: String
    let title: String
    let content: String
    let type: String
    let createDate: String
    let postImageUrls: [String]
    let comments: [Comment]
}

struct Comment: Codable {
    let commentId: Int
    let userId: Int
    let nickname: String
    let profileImageUrl: String
    let content: String
    let createDate: String
}
