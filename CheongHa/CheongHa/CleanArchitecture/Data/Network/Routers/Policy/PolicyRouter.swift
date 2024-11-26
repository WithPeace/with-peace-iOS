//
//  PolicyRouter.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/19/24.
//

import Foundation
import Moya

enum PolicyRouter {
    case fetchHotPolicies
    case fetchRecommendedPolicies
    case fetchPolicies(query: FetchPoliciesQuery)
}

extension PolicyRouter: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchHotPolicies:
            return "/policies/hot"
        case .fetchRecommendedPolicies:
            return "/policies/recommendations"
        case .fetchPolicies:
            return "/policies"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchHotPolicies, .fetchRecommendedPolicies, .fetchPolicies:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchPolicies(let query):
            let parameters: [String: Any] = [
                "region": query.region ?? "",
                "classification": query.classification ?? "",
                "pageIndex": query.pageIndex,
                "display": query.display
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .fetchHotPolicies, .fetchRecommendedPolicies:
            return .requestPlain
        }
    }
}
