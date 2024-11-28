//
//  FilterRouter.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/28/24.
//

import Foundation
import Moya

enum FilterRouter {
    case fetchPolicyFilering
    case changePolicyFilering(query: ChangePolicyFileringQuery)
}

extension FilterRouter: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchPolicyFilering, .changePolicyFilering:
            return "/users/profile/policy-filter"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPolicyFilering:
            return .get
        case .changePolicyFilering:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .changePolicyFilering(let query):
            let parameters: [String: Any] = [
                "region": query.regions.joined(separator: ","),
                "classification": query.classifications.joined(separator: ",")
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .fetchPolicyFilering:
            return .requestPlain
        }
    }
}
