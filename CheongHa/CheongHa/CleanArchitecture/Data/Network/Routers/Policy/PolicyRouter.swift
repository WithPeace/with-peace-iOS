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
    case fetchPolicy(params: FetchPolicyParams)
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
        case .fetchPolicy(let params):
            return "/policies/\(params.policyId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchHotPolicies, .fetchRecommendedPolicies, .fetchPolicies, .fetchPolicy:
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
        case .fetchHotPolicies, .fetchRecommendedPolicies, .fetchPolicy:
            return .requestPlain
        }
    }
}
