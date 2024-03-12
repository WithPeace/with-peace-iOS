//
//  SignRepository.swift
//  WithPeace
//
//  Created by Hemg on 3/12/24.
//

import Foundation

protocol AuthenticationProvider {
    func performGoogleSign(idToken: String,
                           completion: @escaping (Result<SignAuthDTO, SignRepositoryError>) -> Void)
    func performRefresh(refrshToken: String,
                        completion: @escaping (Result<SignAuthDTO, SignRepositoryError>) -> Void)
    func performRegister(accessToken: String, nickname: String,
                         completion: @escaping (Result<SignAuthDTO, SignRepositoryError>) -> Void)
    func performLogout(accessToken: String,
                       completion: @escaping (Result<Void, SignRepositoryError>) -> Void?)
}

final class SignRepository: AuthenticationProvider {
    let keychainManager = KeychainManager()
    
    func performGoogleSign(idToken: String,
                           completion: @escaping (Result<SignAuthDTO, SignRepositoryError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.invalidToken))
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
                    completion(.failure(.invalidToken))
                    return
                } catch {
                    print(error.localizedDescription)
                    return
                }
            case .failure(let error):
                completion(.failure(.unknownError(error)))
            }
        }
    }
    
    //TODO: 401 을 낼때 다시 리프레쉬 토큰을 다시 발급하여 로그인 진행
    func performRefresh(refrshToken: String,
                        completion: @escaping (Result<SignAuthDTO, SignRepositoryError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.invalidToken))
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/auth/google",
                                scheme: "http",
                                queryItems: [],
                                headers: ["Authorization":"Bearer \(refrshToken)"],
                                method: .post)
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let signDTO = try JSONDecoder().decode(SignAuthDTO.self, from: data)
                    
                    guard let accessToken = signDTO.data.accessToken,
                          let refreshdata = signDTO.data.refreshToken else {
                        completion(.failure(.googleInvaidToken))
                        return
                    }
                    
                    guard let refreshdata = refreshdata.data(using: .utf8),
                          let accdata = accessToken.data(using: .utf8) else {
                        return
                    }
                    
                    try self.keychainManager.save(account: "accessToken", password: accdata)
                    try self.keychainManager.save(account: "refreshToken", password: refreshdata)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                completion(.failure(.unknownError(error)))
            }
        }
    }
    
    //TODO: 로그인 메서드
    func performRegister(accessToken: String, nickname: String,
                         completion: @escaping (Result<SignAuthDTO, SignRepositoryError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.invalidToken))
            return
        }
        
        let nicknameModel = Nickname(nickname: nickname)
        guard let requestBody = try? JSONEncoder().encode(nicknameModel) else {
            completion(.failure(.encodingError))
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/auth/google",
                                scheme: "http",
                                queryItems: [],
                                headers: ["Authorization":"Bearer \(accessToken)"],
                                method: .post,
                                body: requestBody)
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    guard let signDTO = try? JSONDecoder().decode(SignAuthDTO.self, from: data) else {
                        completion(.failure(.decodingError))
                        return
                    }
                    
                    guard let accessToken = signDTO.data.accessToken,
                          let refreshdata = signDTO.data.refreshToken else {
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
                    completion(.failure(.invalidToken))
                    return
                } catch {
                    print(error.localizedDescription)
                    return
                }
            case .failure(let error):
                completion(.failure(.unknownError(error)))
            }
        }
    }
    
    //TODO: 로그아웃 메서드
    func performLogout(accessToken: String,
                       completion: @escaping (Result<Void, SignRepositoryError>) -> Void?) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.invalidToken))
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/logout",
                                headers: ["Authorization": "Bearer \(accessToken)"],
                                method: .post)
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(SignAuthResponse.self, from: data)
                    if decodedResponse.data == "logout success" {
                        completion(.success(()))
                    } else {
                        completion(.failure(.decodingError))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure:
                completion(.failure(.bundleError))
            }
        }
    }
}

//MARK: 회원가입 RequestBody
fileprivate struct Nickname: Codable {
    let nickname: String
}

//MARK: Logout Model
fileprivate struct SignAuthResponse: Codable {
    let data: String
    let error: String?
}
