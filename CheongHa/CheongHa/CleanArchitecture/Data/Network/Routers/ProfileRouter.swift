//
//  ProfileRouter.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/6/24.
//

import Foundation
import Moya

enum ProfileRouter {
    case fetchProfile
}

extension ProfileRouter: BaseTargetType {
    
    var path: String {
        switch self {
        case .fetchProfile:
            return "/users/profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchProfile:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchProfile:
            return .requestPlain
        }
    }
}
