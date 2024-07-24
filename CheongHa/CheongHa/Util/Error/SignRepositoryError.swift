//
//  SignRepositoryError.swift
//  WithPeace
//
//  Created by 1 on 3/12/24.
//

enum SignRepositoryError: Error {
    case googleInvalidToken
    case appleInvalidToken
    case networkError
    case notSaveToken
    case tokenAbsenceError
    case bundleError
    case invalidToken
    case notKeychain
    case decodingError
    case encodingError
    case unknownError(Error)
    case logoutFail
    case unauthorized
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "네트워크 Error, Data Fetch Fail"
        case .notSaveToken:
            return "발급받은 토큰이 저장되지 않았습니다."
        case .bundleError:
            return "유효하지 않은 bundle입니다."
        case .invalidToken:
            return "유효하지 않은 토큰 입니다."
        case .notKeychain:
            return "키체인이 없습니다."
        case .decodingError:
            return "디코딩에 실패 했습니다."
        case .googleInvalidToken:
            return "googleSign 토큰 이슈"
        case .appleInvalidToken:
            return "AppleSign 토큰 이슈"
        case .encodingError:
            return "인코딩에 실패 했습니다."
        case .unknownError:
            return "알수없는 오류 입니다."
        case .tokenAbsenceError:
            return "데이터에 토큰이 없습니다."
        case .logoutFail:
            return "로그아웃이 실패했습니다."
        case .unauthorized:
            return "권한이 없습니다."
        }
    }
}

