//
//  PostRouter.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/19/24.
//

import Foundation
import Moya

enum PostRouter {
    case fetchRecentPosts
}

extension PostRouter: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchRecentPosts:
            return "/posts/recents"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchRecentPosts:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchRecentPosts:
            return .requestPlain
        }
    }
}
