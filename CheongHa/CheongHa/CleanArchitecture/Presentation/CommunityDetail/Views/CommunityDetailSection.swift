//
//  CommunityDetailSection.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/25/24.
//

import Foundation

enum CommunityDetailSection: Int, CaseIterable {
    case post = 0
    case comment
}

enum CommunityDetailSectionItem: Hashable {
    case post(data: CommunityDetailSectionDataCollection)
    case comment(data: CommunityDetailSectionDataCollection)
    
    var data: CommunityDetailSectionDataCollection {
        switch self {
        case .post(let data):
            return data
        case .comment(let data):
            return data
        }
    }
}

struct  CommunityDetailSectionDataCollection: Hashable {
    let postDetailData: PostDetailItemData
    let commentData: CommentItemData
    
    init(
        postDetailData: PostDetailItemData = .init(),
        commentData: CommentItemData = .init()
    ) {
        self.postDetailData = postDetailData
        self.commentData = commentData
    }
    
    struct PostDetailItemData: Hashable {
        let postId: Int
        let userId: Int
        let nickname: String
        let profileImageUrl: String
        let title: String
        let content: String
        let type: PostType
        let createDate: String
        let postImageUrls: [String]
        
        init(
            postId: Int = 0,
            userId: Int = 0,
            nickname: String = "",
            profileImageUrl: String = "",
            title: String = "",
            content: String = "",
            type: PostType = .freedom,
            createDate: String = "",
            postImageUrls: [String] = []
        ) {
            self.postId = postId
            self.userId = userId
            self.nickname = nickname
            self.profileImageUrl = profileImageUrl
            self.title = title
            self.content = content
            self.type = type
            self.createDate = createDate
            self.postImageUrls = postImageUrls
        }
    }
    
    struct CommentItemData: Hashable {
        let commentId: Int
        let userId: Int
        let nickname: String
        let postImageUrls: String
        let content: String
        let createDate: String
        
        init(
            commentId: Int = 0,
            userId: Int = 0,
            nickname: String = "",
            postImageUrls: String = "",
            content: String = "",
            createDate: String = ""
        ) {
            self.commentId = commentId
            self.userId = userId
            self.nickname = nickname
            self.postImageUrls = postImageUrls
            self.content = content
            self.createDate = createDate
        }
    }
}
