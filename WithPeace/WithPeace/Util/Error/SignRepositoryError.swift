//
//  SignRepositoryError.swift
//  WithPeace
//
//  Created by 1 on 3/12/24.
//

enum SignRepositoryError: Error {
    case bundleError
    case invalidToken
    case notKeychain
    case decodingError
    case googleInvaidToken
    case encodingError
    case unknownError(Error)
    
    var errorDescription: String? {
        switch self {
        case .bundleError:
            return "유효하지 않은 bundle입니다."
        case .invalidToken:
            return "유효하지 않은 토큰 입니다."
        case .notKeychain:
            return "키체인이 없습니다."
        case .decodingError:
            return "디코딩에 실패 했습니다."
        case .googleInvaidToken:
            return "googleSign 토큰 이슈"
        case .encodingError:
            return "인코딩에 실패 했습니다."
        case .unknownError:
            return "알수없는 오류 입니다."
        }
    }
}

