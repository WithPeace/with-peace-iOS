//
//  CommunityDetailSection.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/25/24.
//

import Foundation

enum CommunityDetailSection: Int, CaseIterable {
    case postAndComment = 0
}

struct CommentItem: Identifiable, Hashable {
    let id: Int
    let userId: Int
    let profileImageURL: String
    let nickname: String
    let content: String
    let createDate: String
}
