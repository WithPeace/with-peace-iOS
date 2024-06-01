//
//  ProfileRepository.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/23/24.
//

import Foundation

protocol ProfileProvider {
    associatedtype ProfileDuplicate
    associatedtype ProfileStringData
    
    func searchProfile(completion: @escaping (Result<ProfileData, ProfileError>) -> Void)
    func changeProfile(nickname: String,
                       imageData: Data,
                       completion: @escaping (Result<ProfileDTO, ProfileError>) -> Void)
    func changeProfile(nickname: String,
                       completion: @escaping (Result<ProfileStringDTO, ProfileError>) -> Void)
    func changeProfile(imageData: Data,
                       completion: @escaping (Result<ProfileStringDTO, ProfileError>) -> Void)
    func checkNickname(nickname: String,
                       completion: @escaping (Result<Bool, ProfileError>) -> Void)
    func deleteProfileImage(completion: @escaping (Result<Void, ProfileError>) -> Void)
}

@available(*, deprecated, message: "Using - ProfileAPIRepository.")
final class ProfileRepository: ProfileProvider {
    private let keyChainManager = KeychainManager()
    private let signRepository = SignRepository()
    
    struct ProfileDuplicate: Codable {
        let data: Bool
        let error: String?
    }
    
    struct ProfileStringData: Codable {
        let data: String?
        let error: String?
    }
    
    /// 유저 프로필 조회
    func searchProfile(completion: @escaping (Result<ProfileData, ProfileError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleError))
            return
        }
        
        guard let accessToken = keyChainManager.get(account: "accessToken") else {
            completion(.failure(.notHaveToken))
            return
        }
        
        guard let accessToken = String(data: accessToken, encoding: .utf8) else {
            completion(.failure(.decodeError))
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/users/profile",
                                port: 8080,
                                scheme: "http",
                                headers: ["Authorization":"Bearer \(accessToken)"],
                                method: .get)
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let profileDTO = try JSONDecoder().decode(ProfileDTO.self, from: data)
                    completion(.success(profileDTO.data!))
                } catch {
                    completion(.failure(.decodeError))
                    return
                }
            case .failure(let error):
                debugPrint(error)
                self.signRepository.performRefresh { result in
                    switch result {
                    case .success(_):
                        debugPrint("Success Renew Refresh")
                    case .failure(let error):
                        debugPrint(error.errorDescription ?? "ERROR - PerformRefresh")
                    }
                }
                completion(.failure(.networkManagerError))
            }
        }
    }
    
    ///유저 프로필 변경
    func changeProfile(nickname: String, imageData: Data, completion: @escaping (Result<ProfileDTO, ProfileError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleError))
            return
        }
        
        guard let accessToken = keyChainManager.get(account: "accessToken") else {
            completion(.failure(.notHaveToken))
            return
        }
        
        guard let accessToken = String(data: accessToken, encoding: .utf8) else {
            completion(.failure(.decodeError))
            return
        }
        
        var formData = MultipartFormData()
        formData.createFormFiled(name: "nickname", value: nickname)
        formData.addFilesBodyData(fieldName: "imageFile",
                                  fileName: "image.jpg",
                                  mimeType: "image/jpeg",
                                  fileData: imageData)
        
        var header = formData.generateHeader()
        header["Authorization"] = "Bearer \(accessToken)"
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/users/profile",
                                port: 8080,
                                scheme: "http",
                                headers: header,
                                method: .put,
                                body: formData.generateData())
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let data = try JSONDecoder().decode(ProfileDTO.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(.decodeError))
                    return
                }
            case .failure(let error):
                debugPrint(error)
                self.signRepository.performRefresh { result in
                    switch result {
                    case .success(_):
                        debugPrint("Success Renew Refresh")
                    case .failure(let error):
                        print(error)
                    }
                }
                completion(.failure(.networkManagerError))
            }
        }
    }
    
    func changeProfile(nickname: String, completion: @escaping (Result<ProfileStringDTO, ProfileError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleError))
            return
        }
        
        guard let accessToken = keyChainManager.get(account: "accessToken") else {
            completion(.failure(.notHaveToken))
            return
        }
        
        guard let accessToken = String(data: accessToken, encoding: .utf8) else {
            completion(.failure(.decodeError))
            return
        }
        
        var nicknameData = Data()
        
        do {
            nicknameData = try JSONSerialization.data(withJSONObject: ["nickname":nickname])
        } catch {
            debugPrint("ERROR - nicknameData")
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/users/profile/nickname",
                                port: 8080,
                                scheme: "http",
                                headers: ["Authorization":"Bearer \(accessToken)",
                                          "Content-Type":"application/json"],
                                method: .patch,
                                body: nicknameData
        )
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(ProfileStringDTO.self, from: data)
                    completion(.success(decodedData))
                } catch {
                    completion(.failure(.decodeError))
                    return
                }
            case .failure(let error):
                debugPrint(error)
                self.signRepository.performRefresh { result in
                    switch result {
                    case .success(_):
                        debugPrint("Success Renew Refresh")
                    case .failure(let error):
                        print(error)
                    }
                }
                completion(.failure(.networkManagerError))
            }
        }
    }
    
    
    /// 유저 프로필 변경 (이미지만)
    func changeProfile(imageData: Data, completion: @escaping (Result<ProfileStringDTO, ProfileError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleError))
            return
        }
        
        guard let accessToken = keyChainManager.get(account: "accessToken") else {
            completion(.failure(.notHaveToken))
            
            return
        }
        
        guard let accessToken = String(data: accessToken, encoding: .utf8) else {
            completion(.failure(.decodeError))
            return
        }
        
        var formData = MultipartFormData()
        formData.addFilesBodyData(fieldName: "imageFile",
                                  fileName: "image.jpg",
                                  mimeType: "image/jpeg",
                                  fileData: imageData)
        
        var header = formData.generateHeader()
        header["Authorization"] = "Bearer \(accessToken)"
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/users/profile/image",
                                port: 8080,
                                scheme: "http",
                                headers: header,
                                method: .patch,
                                body: formData.generateData())
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let data = try JSONDecoder().decode(ProfileStringDTO.self, from: data)
                    completion(.success(data))
                } catch {
                    completion(.failure(.decodeError))
                    return
                }
            case .failure(let error):
                debugPrint(error)
                self.signRepository.performRefresh { result in
                    switch result {
                    case .success(_):
                        debugPrint("Success Renew Refresh")
                    case .failure(let error):
                        print(error)
                    }
                }
                completion(.failure(.networkManagerError))
            }
        }
    }
    
    /// 유저 프로필 닉네임 중복 확인
    func checkNickname(nickname: String, completion: @escaping (Result<Bool, ProfileError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleError))
            return
        }
        
        guard let accessToken = keyChainManager.get(account: "accessToken") else {
            completion(.failure(.notHaveToken))
            return
        }
        
        guard let accessToken = String(data: accessToken, encoding: .utf8) else {
            completion(.failure(.decodeError))
            return
        }
        
        let query = [URLQueryItem(name: "nickname", value: nickname)]
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/users/profile/nickname/check",
                                port: 8080,
                                scheme: "http",
                                queryItems: query,
                                headers: ["Authorization":"Bearer \(accessToken)"],
                                method: .get)
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let data):
                do {
                    let data = try JSONDecoder().decode(ProfileDuplicate.self, from: data)
                    completion(.success(data.data))
                } catch {
                    completion(.failure(.decodeError))
                    return
                }
            case .failure(let error):
                debugPrint(error)
                self.signRepository.performRefresh { result in
                    switch result {
                    case .success(_):
                        debugPrint("Success Renew Refresh")
                    case .failure(let error):
                        print(error)
                    }
                }
                completion(.failure(.networkManagerError))
            }
        }
    }
    
    /// 유저 프로필 이미지 삭제
    func deleteProfileImage(completion: @escaping (Result<Void, ProfileError>) -> Void) {
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleError))
            return
        }
        
        guard let accessToken = keyChainManager.get(account: "accessToken") else {
            completion(.failure(.notHaveToken))
            return
        }
        
        guard let accessToken = String(data: accessToken, encoding: .utf8) else {
            completion(.failure(.decodeError))
            return
        }
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/users/profile/image",
                                port: 8080,
                                scheme: "http",
                                headers: ["Authorization":"Bearer \(accessToken)"],
                                method: .delete)
        
        NetworkManager.shared.fetchData(endpoint: endPoint) { result in
            switch result {
            case .success(_):
                completion(.success(Void()))
            case .failure(let error):
                debugPrint(error)
                self.signRepository.performRefresh { result in
                    switch result {
                    case .success(_):
                        debugPrint("Success Renew Refresh")
                    case .failure(let error):
                        debugPrint(error)
                    }
                }
                completion(.failure(.networkManagerError))
            }
        }
    }
}

struct ProfileDTO: Codable {
    var data: ProfileData?
    var error: String?
}

struct ProfileStringDTO: Codable {
    var data: String?
    var error: String?
}

struct ProfileData: Codable {
    var userId: Int?
    var email: String
    var profileImageUrl: String //기본 Image의 경우 default.png
    var nickname: String
}
