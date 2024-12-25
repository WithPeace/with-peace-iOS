//
//  CommunityCategory.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/21/24.
//

import UIKit

enum CommunityCategory: Int, CaseIterable {
    case free = 0
    case info
    case question
    case living
    case hobby
    case economy
    
    var iconNotSelectedImage: ImageResource {
        switch self {
        case .free:
            return .icFreeTagNotSelected
        case .info:
            return .icInfoTagNotSelected
        case .question:
            return .icQuestionTagNotSelected
        case .living:
            return .icLifeTagNotSelected
        case .hobby:
            return .icHobbyTagNotSelected
        case .economy:
            return .icEconomyTagNotSelected
        }
    }
    
    var iconSelectedImage: ImageResource {
        switch self {
        case .free:
            return .icFreeTagSelected
        case .info:
            return .icInfoTagSelected
        case .question:
            return .icQuestionTagSelected
        case .living:
            return .icLifeTagSelected
        case .hobby:
            return .icHobbyTagSelected
        case .economy:
            return .icEconomyTagSelected
        }
    }
    
    var categoryName: String {
        switch self {
        case .free:
            return "자유"
        case .info:
            return "정보"
        case .question:
            return "질문"
        case .living:
            return "생활"
        case .hobby:
            return "취미"
        case .economy:
            return "경제"
        }
    }
    
    var convertToPostType: PostType {
        switch self {
        case .free:
            return .freedom
        case .info:
            return .information
        case .question:
            return .question
        case .living:
            return .living
        case .hobby:
            return .hobby
        case .economy:
            return .economy
        }
    }
}
