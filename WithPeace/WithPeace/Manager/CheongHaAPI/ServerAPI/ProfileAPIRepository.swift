//
//  ProfileAPIRepository.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/8/24.
//

import Foundation

final class ProfileAPIRepository {
    private let keyChainManager = KeychainManager()
    private let signRepository = SignRepository()
    private let serverAuthManager = ServerAuthManager()
    
    /// Recovery User
    func recoveryUser(with email: String, completion: @escaping (Result<Bool, ServerAPIError>) -> Void) {
        
        let emailData = email.data(using: .utf8)
        
        serverAuthManager.common(path: "/api/v1/users/recovery",
                                 httpMethod: .patch,
                                 body: emailData) { (result: Result<Bool?, ServerAPIError>) in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(.dataBindError))
                    return
                }
                completion(.success(data))
            case .failure(let error):
                completion(.failure(.failureError))
                debugPrint(error)
            }
        }
    }
    
    /// Resign User
    func resignUser(completion: @escaping (Result<Bool, ServerAPIError>) -> Void) {
    
    serverAuthManager.common(path: "/api/v1/users",
                             httpMethod: .delete) { (result: Result<Bool?, ServerAPIError>) in
        switch result {
        case .success(let data):
            guard let data = data else {
                self.keyChainManager.delete(account: "accessToken")
                self.keyChainManager.delete(account: "refreshToken")
                completion(.failure(.dataBindError))
                return
            }
            completion(.success(data))
        case .failure(let error):
            completion(.failure(.failureError))
            debugPrint(error)
        }
    }
}
    
    /// Search User Profile
    func searchProfile(completion: @escaping (Result<SearchDataDTO, ServerAPIError>) -> Void) {
        serverAuthManager.common(path: "/api/v1/users/profile",
                                 httpMethod: .get) { (result: Result<SearchDataDTO?, ServerAPIError>) in
            switch result {
            case .success(let fetchedData):
                guard let fetchedData = fetchedData else {
                    completion(.failure(.dataBindError))
                    return
                }
                completion(.success(fetchedData))
            case .failure(let error):
                print(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// Change User Profile
    func changeProfile(nickname: String,
                       imageData: Data,
                       completion: @escaping (Result<SearchDataDTO, ServerAPIError>) -> Void) {
        
        var formData = MultipartFormData()
        formData.createFormFiled(name: "nickname", value: nickname)
        formData.addFilesBodyData(fieldName: "imageFile",
                                  fileName: "image.jpg",
                                  mimeType: "image/jpeg",
                                  fileData: imageData)
        
        let header = formData.generateHeader()
        
        self.serverAuthManager.common(path: "/api/v1/users/profile",
                                      headers: header,
                                      httpMethod: .put,
                                      body: formData.generateData()) { (result: Result<SearchDataDTO?, ServerAPIError>) in
            switch result {
            case .success(let fetchedData):
                guard let fetchedData = fetchedData else {
                    completion(.failure(.dataBindError))
                    return
                }
                completion(.success(fetchedData))
            case .failure(let error):
                print(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// Change Only Nickname
    func changeProfile(nickname: String,
                       completion: @escaping (Result<String, ServerAPIError>) -> Void) {
        var nicknameData = Data()
        
        do {
            nicknameData = try JSONSerialization.data(withJSONObject: ["nickname":nickname])
        } catch {
            debugPrint("ERROR - nicknameData")
            completion(.failure(.decodeError))
            return
        }
        
        serverAuthManager.common(path: "/api/v1/users/profile/nickname",
                                 headers: ["Content-Type":"application/json"],
                                 httpMethod: .patch,
                                 body: nicknameData) { (result: Result<String?, ServerAPIError>) in
            switch result {
            case .success(let fetchedData):
                guard let fetchedData = fetchedData else {
                    completion(.failure(.dataBindError))
                    return
                }
                completion(.success(fetchedData))
            case .failure(let error):
                print(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// Change Only Image -> string = ImagePath
    func changeProfile(imageData: Data,
                       completion: @escaping (Result<String, ServerAPIError>) -> Void) {
        var formData = MultipartFormData()
        formData.addFilesBodyData(fieldName: "imageFile",
                                  fileName: "image.jpg",
                                  mimeType: "image/jpeg",
                                  fileData: imageData)
        
        let header = formData.generateHeader()
        
        serverAuthManager.common(path: "/api/v1/users/profile/image",
                                 headers: header,
                                 httpMethod: .patch,
                                 body: formData.generateData()) { (result: Result<String?, ServerAPIError>)  in
            switch result {
            case .success(let fetchedData):
                guard let fetchedData = fetchedData else {
                    completion(.failure(.dataBindError))
                    return
                }
                
                completion(.success(fetchedData))
            case .failure(let error):
                print(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// Check Nickname Duplicate
    func checkNickname(nickname: String, completion: @escaping (Result<Bool, ServerAPIError>) -> Void) {
        let query = [URLQueryItem(name: "nickname", value: nickname)]
        
        serverAuthManager.common(path: "/api/v1/users/profile/nickname/check",
                                 queryItems: query,
                                 httpMethod: .get) { (result: Result<Bool?, ServerAPIError>) in
            switch result {
            case .success(let fetchedData):
                guard let fetchedData = fetchedData else {
                    completion(.failure(.dataBindError))
                    return
                }
                
                completion(.success(fetchedData))
            case .failure(let error):
                print(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// Delete Profile Image
    func deleteProfileImage(completion: @escaping (Result<String, ServerAPIError>) -> Void) {
        serverAuthManager.common(path: "/api/v1/users/profile/image",
                                 httpMethod: .delete)  { (result: Result<String?, ServerAPIError>) in
            switch result {
            case .success(let fetchedData):
                guard let fetchedData = fetchedData else {
                    completion(.failure(.dataBindError))
                    return
                }
                
                completion(.success(fetchedData))
            case .failure(let error):
                print(error)
                completion(.failure(.failureError))
            }
        }
    }
}
