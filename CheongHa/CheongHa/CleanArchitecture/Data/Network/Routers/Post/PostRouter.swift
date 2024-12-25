//
//  PostRouter.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/19/24.
//

import Foundation
import Moya

enum PostRouter {
    case fetchPosts(query: FetchPostsQuery)
    case fetchPostDetail(params: FetchPostDetailParams)
    case fetchRecentPosts
}

extension PostRouter: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchPosts:
            return "/posts"
        case .fetchPostDetail(let params):
            return "/posts/\(params.postId)"
        case .fetchRecentPosts:
            return "/posts/recents"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPosts, .fetchPostDetail, .fetchRecentPosts:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchPosts(let query):
            let parameters: [String: Any] = [
                "type": query.type,
                "pageIndex": query.pageIndex,
                "pageSize": query.pageSize
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .fetchPostDetail, .fetchRecentPosts:
            return .requestPlain
        }
    }
}
