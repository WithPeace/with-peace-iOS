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
    case life
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
        case .life:
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
        case .life:
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
        case .life:
            return "생활"
        case .hobby:
            return "취미"
        case .economy:
            return "경제"
        }
    }
}
