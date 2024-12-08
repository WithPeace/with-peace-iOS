//
//  PostType.swift
//  WithPeace
//
//  Created by Dylan_Y on 6/17/24.
//

enum PostType: String, Codable, CaseIterable {
    case freedom = "FREEDOM"
    case information = "INFORMATION"
    case question = "QUESTION"
    case living = "LIVING"
    case hobby = "HOBBY"
    case economy = "ECONOMY"
    
    var postTitle: String {
        switch self {
        case .freedom:
            return "자유게시판"
        case .information:
            return "정보게시판"
        case .question:
            return "질문게시판"
        case .living:
            return "생활게시판"
        case .hobby:
            return "취미게시판"
        case .economy:
            return "경제게시판"
        }
    }
}
