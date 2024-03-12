//
//  GoogleSignError.swift
//  WithPeace
//
//  Created by Hemg on 3/12/24.
//

import Foundation

enum GoogleSignError: LocalizedError {
    case googleNetworkError
    case idtokenError
    case signInResult
  
    var errorDescription: String? {
        switch self {
        case .googleNetworkError:
            return "로그인에 실패 했습니다."
        case .idtokenError:
            return "id토큰을 찾을 수 없습니다."
        case .signInResult:
            return "signInResult"
        }
    }
}
