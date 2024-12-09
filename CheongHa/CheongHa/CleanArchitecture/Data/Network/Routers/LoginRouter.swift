//
//  LoginRouter.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/4/24.
//

import Foundation
import Moya

// TODO: 이름 변경 LoginRouter -> AuthRouter
enum LoginRouter {
    case googleSocialLogin(idToken: String)
    case appleSocialLogin(idToken: String)
    case refreshToken
}

extension LoginRouter: BaseTargetType {
    
    var path: String {
        switch self {
        case .googleSocialLogin:
            return "/auth/google"
        case .appleSocialLogin:
            return "/auth/apple"
        case .refreshToken:
            return "/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .googleSocialLogin, .appleSocialLogin, .refreshToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .googleSocialLogin, .appleSocialLogin, .refreshToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .googleSocialLogin(let idToken):
            return ["Authorization" : "Bearer \(idToken)"]
        case .appleSocialLogin(let idToken):
            return ["Authorization" : "Bearer \(idToken)"]
        case .refreshToken:
            let keyChainManager = KeychainManager()
            guard let keyChainAccessToken = keyChainManager.get(account: "refreshToken"),
                  let refreshToken = String(data: keyChainAccessToken, encoding: .utf8)
            else { return nil }

            print("refreshToken: \(refreshToken)")
            return ["Authorization": "Bearer \(refreshToken)"]
        }
    }
}
