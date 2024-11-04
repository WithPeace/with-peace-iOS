//
//  LoginRouter.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/4/24.
//

import Foundation
import Moya

enum LoginRouter {
    case googleSocialLogin(idToken: String)
    case appleSocialLogin(idToken: String)
}

extension LoginRouter: TargetType {
    var baseURL: URL {
        return URL(string: APIKeys.baseURL)!
    }
    
    var path: String {
        switch self {
        case .googleSocialLogin:
            return "/auth/google"
        case .appleSocialLogin:
            return "/auth/apple"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .googleSocialLogin, .appleSocialLogin:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .googleSocialLogin, .appleSocialLogin:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .googleSocialLogin(let idToken):
            return ["Authorization" : "Bearer \(idToken)"]
        case .appleSocialLogin(let idToken):
            return ["Authorization" : "Bearer \(idToken)"]
        }
    }
}

