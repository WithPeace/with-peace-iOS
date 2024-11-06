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
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    var headers: [String : String]? {
        return nil
    }
}
