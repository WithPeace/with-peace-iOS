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
}

extension AuthRouter: BaseTargetType {

    var path: String {
        switch self {
        case .logout:
            return "/auth/logout"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .logout:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .logout:
            return .requestPlain
        }
    }
}
