//
//  AuthRouter.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/9/24.
//

import Foundation
import Moya

enum AuthRouter {
    case logout
    case withdrawal
}

extension AuthRouter: BaseTargetType {

    var path: String {
        switch self {
        case .logout:
            return "/auth/logout"
        case .withdrawal:
            return "/users"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logout:
            return .post
        case .withdrawal:
            return .delete
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .logout, .withdrawal:
            return .requestPlain
        }
    }
}
