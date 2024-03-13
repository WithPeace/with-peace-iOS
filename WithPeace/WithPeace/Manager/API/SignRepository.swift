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
    func performRefresh(completion: @escaping (Result<Void, SignRepositoryError>) -> Void)
    func performRegister(nickname: String,
                         completion: @escaping (Result<Void, SignRepositoryError>) -> Void)
    func performLogout(completion: @escaping (Result<Void, SignRepositoryError>) -> Void)
}

final class SignRepository: AuthenticationProvider {
    private let keychainManager = KeychainManager()
    private var isValid: Bool = true
    
    func performGoogleSign(idToken: String,
                           completion: @escaping (Result<SignAuthDTO, SignRepositoryError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleError))
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/auth/google",
                                port: 8080,
                                scheme: "http",
                                headers: ["Authorization":"Bearer \(idToken)"],
                                method: .post)
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let signDTO = try JSONDecoder().decode(SignAuthDTO.self, from: data)
                    
                    guard let accessToken = signDTO.data.jwtTokenDto?.accessToken,
                          let refreshToken = signDTO.data.jwtTokenDto?.refreshToken else {
                        completion(.failure(.googleInvalidToken))
                        return
                    }
                    
                    try self.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                    completion(.success(signDTO))
                } catch {
                    completion(.failure(.notSaveToken))
                    return
                }
            case .failure(_):
                completion(.failure(.networkError))
            }
        }
    }
    
    func performRefresh(completion: @escaping (Result<Void, SignRepositoryError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleError))
            return
        }
        
        guard let keychainAccessToken = keychainManager.get(account: "refreshToken") else {
            completion(.failure(.notKeychain))
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/auth/refresh",
                                port: 8080,
                                scheme: "http",
                                headers: ["Authorization":"Bearer \(keychainAccessToken)"],
                                method: .post)
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let signDTO = try JSONDecoder().decode(SignAuthDTO.self, from: data)
                    
                    guard let accessToken = signDTO.data.accessToken,
                          let refreshToken = signDTO.data.refreshToken else {
                        completion(.failure(.tokenAbsenceError))
                        return
                    }
                    
                    try self.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                    completion(.success(()))
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure(let error):
                if error == .unauthorized {
                    //TODO: - Logout 진행시 Access token 필요함. 만료되었는데 로그아웃을 어떻게 진행할 것인가?
                    // 리프레쉬도 만료 되었으니, 재로그인
                    // 그렇다면 재로그인? 로그아웃을 한 뒤 로그인을 해야하는 것 아닌가?
                    // 서버에서 우리가 로그아웃 하지 않았는데, 로그인이 되었다면 어떻게 되는것인가?
                    //      만약 서버에서 로그인시도가 있을 때 자동 로그아웃 처리되면 우리는 그냥 로그인다시하면됨.
                    // 하지만 서버에서 로그아웃 -> 로그인 을 원하면? 그건 다시생각야함.
                } else {
                    completion(.failure(.networkError))
                }
            }
        }
    }
    
    //TODO: 회원가입 메서드 (회원가입 완료 시 : role: guest -> user)
    func performRegister(nickname: String,
                         completion: @escaping (Result<Void, SignRepositoryError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleError))
            return
        }
        
        guard let keychainAccessToken = keychainManager.get(account: "accessToken") else {
            completion(.failure(.notKeychain))
            return
        }
        
        let nicknameModel = Nickname(nickname: nickname)
        
        guard let requestBody = try? JSONEncoder().encode(nicknameModel) else {
            completion(.failure(.encodingError))
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/auth/register",
                                port: 8080,
                                scheme: "http",
                                headers: ["Authorization":"Bearer \(keychainAccessToken)"],
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
                          let refreshToken = signDTO.data.refreshToken else {
                        completion(.failure(.tokenAbsenceError))
                        return
                    }
                    
                    try self.saveTokens(accessToken: accessToken, refreshToken: refreshToken)
                    completion(.success(()))
                } catch {
                    completion(.failure(.decodingError))
                    return
                }
            case .failure(let error):
                if error == .unauthorized {
                    //401 일 때 리프레쉬로 엑세스 먼저 발급
                    self.performRefresh { result in
                        switch result {
                        case .success(_):
                            self.performRegister(nickname: nickname, completion: completion)
                        case .failure(_):
                            //TODO: LogOut
                            debugPrint("PERFORM REGISTER _ REFRESH ERROR : Please LogOut")
                            
                            break
                        }
                    }
                } else {
                    completion(.failure(.networkError))
                }
            }
        }
    }
    
    //TODO: 로그아웃 메서드
    func performLogout(completion: @escaping (Result<Void, SignRepositoryError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleError))
            return
        }
        
        guard let keychainAccessToken = keychainManager.get(account: "accessToken") else {
            completion(.failure(.notKeychain))
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/auth/logout",
                                port: 8080,
                                scheme: "http",
                                headers: ["Authorization": "Bearer \(keychainAccessToken)"],
                                method: .post)
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedResponse = try JSONDecoder().decode(SignAuthResponse.self, from: data)
                    if decodedResponse.data == "logout success" {
                        completion(.success(()))
                    } else {
                        completion(.failure(.logoutFail))
                    }
                } catch {
                    completion(.failure(.decodingError))
                }
            case .failure:
                //TODO: - 토큰 만료시 로그아웃 여부 확인 후 구현
                completion(.failure(.networkError))
            }
        }
    }
    
    private func saveTokens(accessToken: String, refreshToken: String) throws {
        guard let refreshToken = refreshToken.data(using: .utf8),
              let accessToken = accessToken.data(using: .utf8) else {
            throw SignRepositoryError.invalidToken
        }
        
        try self.keychainManager.save(account: "accessToken", password: accessToken)
        try self.keychainManager.save(account: "refreshToken", password: refreshToken)
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
