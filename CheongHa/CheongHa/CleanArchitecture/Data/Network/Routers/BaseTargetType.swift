//
//  BaseTargetType.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/6/24.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType {
    
}

extension BaseTargetType {
    
    var baseURL: URL {
        return URL(string: APIKeys.baseURL)!
    }
    
    var headers: [String : String]? {
        let keyChainManager = KeychainManager()
        guard let keyChainAccessToken = keyChainManager.get(account: "accessToken"),
              let accessToken = String(data: keyChainAccessToken, encoding: .utf8)
        else { return nil }

        print("accessToken: \(accessToken)")
        return ["Authorization": "Bearer \(accessToken)"]
    }
}
