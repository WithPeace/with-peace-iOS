//
//  ServerAPIError.swift
//  WithPeace
//
//  Created by Dylan_Y on 6/17/24.
//

import Foundation

enum ServerAPIError: Error {
    case bundleError
    case notHaveToken
    case decodeError
    case networkManagerError
    case bundleURLError
    
    // 추가
    case dataBindError
    case failureError // ServerAuthManager Error
    case unKnownError
}
