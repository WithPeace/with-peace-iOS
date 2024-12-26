//
//  CommunityDetailCategory.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/26/24.
//

import UIKit

extension PostType {
    var communityDetailCategory: ImageResource {
        switch self {
        case .freedom:
            return .icCateFreeFrame
        case .information:
            return .icCateInfoFrame
        case .question:
            return .icCateQuestionFrame
        case .living:
            return .icCateLivingFrame
        case .hobby:
            return .icCateHobbyFrame
        case .economy:
            return .icCateEcoFrame
        }
    }
}
