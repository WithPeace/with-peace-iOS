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
}

extension FilterRouter: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchPolicyFilering:
            return "/users/profile/policy-filter"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchPolicyFilering:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchPolicyFilering:
            return .requestPlain
        }
    }
}
