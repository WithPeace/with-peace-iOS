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
}

extension PolicyRouter: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchHotPolicies:
            return "/policies/hot"
        case .fetchRecommendedPolicies:
            return "/policies/recommendations"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchHotPolicies, .fetchRecommendedPolicies:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchHotPolicies, .fetchRecommendedPolicies:
            return .requestPlain
        }
    }
}
