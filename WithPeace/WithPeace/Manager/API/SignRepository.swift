//
//  SignRepository.swift
//  WithPeace
//
//  Created by Hemg on 3/12/24.
//

import Foundation

final class SignRepository {
    let keychainManager = KeychainManager()
    
    func googleSign(idToken: String, completion: @escaping (Result<SignAuthDTO, SignRepositoryError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.invaidToken))
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/auth/google",
                                scheme: "http",
                                queryItems: [],
                                headers: ["Authorization":"Bearer \(idToken)"],
                                method: .post)
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let signDTO = try JSONDecoder().decode(SignAuthDTO.self, from: data)
                    
                    guard let accessToken = signDTO.data.jwtTokenDto?.accessToken,
                          let refreshdata = signDTO.data.jwtTokenDto?.refreshToken else {
                        completion(.failure(.googleInvaidToken))
                        return
                    }
                    
                    guard let refreshdata = refreshdata.data(using: .utf8),
                          let accdata = accessToken.data(using: .utf8) else {
                        return
                    }
                    
                    try self.keychainManager.save(account: "accessToken", password: accdata)
                    try self.keychainManager.save(account: "refreshToken", password: refreshdata)
                } catch KeychainError.duplicateEntry {
                    completion(.failure(.invaidToken))
                    return
                } catch {
                    print(error.localizedDescription)
                    return
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

enum SignRepositoryError: Error {
    case bundleError
    case invaidToken
    case notKeychain
    case decodingError
    case googleInvaidToken
    
    var errorDescription: String? {
        switch self {
        case .bundleError:
            return "유효하지 않은 bundle입니다."
        case .invaidToken:
            return "유효하지 않은 토큰 입니다."
        case .notKeychain:
            return "키체인이 없습니다."
        case .decodingError:
            return "디코딩에 실패 했습니다."
        case .googleInvaidToken:
            return "googleSign 토큰 이슈"
        }
    }
}
