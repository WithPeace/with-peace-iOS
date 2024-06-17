//
//  PostAPIRepository.swift
//  WithPeace
//
//  Created by Dylan_Y on 6/15/24.
//

import Foundation

final class PostAPIRepository {
    private let keyChainManager = KeychainManager()
    private let signRepository = SignRepository()
    private let serverAuthManager = ServerAuthManager()
    
    /// Post Register
    func register(title: String,
                  content: String,
                  type: PostType,
                  imageDatas: [Data]? = nil,
                  completion: @escaping (Result<PostDTOpostID, ServerAPIError>) -> Void) {
        
        var formData =  MultipartFormData()
        formData.createFormFiled(name: "title", value: title)
        formData.createFormFiled(name: "content", value: content)
        formData.createFormFiled(name: "type", value: type.rawValue)
        
        if let imageDatas = imageDatas {
            for imageData in imageDatas {
                formData.addFilesBodyData(fieldName: "imageFiles",
                                          fileName: "image/jpg",
                                          mimeType: "image/jpeg",
                                          fileData: imageData)
            }
        }
        
        let header = formData.generateHeader()
        
        serverAuthManager.common(path: "/api/v1/posts/register",
                                 headers: header,
                                 httpMethod: .post,
                                 body: formData.generateData()) { (result: Result<PostDTOpostID?, ServerAPIError>) in
            
            switch result {
            case .success(let data):
                guard let fetchData = data else {
                    completion(.failure(.dataBindError))
                    return
                }
                
                completion(.success(fetchData))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// Search Detail Post
    func searchDetail(postId: Int,
                      completion: @escaping (Result<PostDetailItem, ServerAPIError>) -> Void) {
        
        serverAuthManager.common(path: "/api/v1/posts/\(postId)",
                                 httpMethod: .get) { (result: Result<PostDetailItem?, ServerAPIError>) in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(.failureError))
                    return
                }
                
                completion(.success(data))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// Search List Post
    /// - Parameters:
    ///     - pageIndex: from 0
    ///     - pageSize: form 0
    ///
    /// 값이 없으면 빈배열 return
    func searchList(type: PostType,
                    pageIndex: Int,
                    pageSize: Int,
                    completion: @escaping (Result<[PostListItem], ServerAPIError>) -> Void) {
        
        let urlQueryItme = [URLQueryItem(name: "type", value: type.rawValue),
                            URLQueryItem(name: "pageIndex", value: String(pageIndex)),
                            URLQueryItem(name: "pageSize", value: String(pageSize))]
        
        serverAuthManager.common(path: "/api/v1/posts",
                                 queryItems: urlQueryItme,
                                 httpMethod: .get) { (result: Result<[PostListItem]?, ServerAPIError>) in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(.failure(.failureError))
                    return
                }
                
                completion(.success(data))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// Modify Post
    func modify(postId: Int,
                title: String,
                content: String,
                type: PostType,
                imageDatas: [Data]?,
                completion: @escaping (Result<PostDTOpostID, ServerAPIError>) -> Void) {
        
        
        var formData =  MultipartFormData()
        formData.createFormFiled(name: "title", value: title)
        formData.createFormFiled(name: "content", value: content)
        formData.createFormFiled(name: "type", value: type.rawValue)
        
        if let imageDatas = imageDatas {
            for imageData in imageDatas {
                formData.addFilesBodyData(fieldName: "imageFiles",
                                          fileName: "image/jpg",
                                          mimeType: "image/jpeg",
                                          fileData: imageData)
            }
        }
        
        let header = formData.generateHeader()
        
        serverAuthManager.common(path: "/api/v1/posts/\(postId)",
                                 headers: header,
                                 httpMethod: .put,
                                 body: formData.generateData()) { (result: Result<PostDTOpostID?, ServerAPIError>) in
            
            switch result {
            case .success(let data):
                guard let fetchData = data else {
                    completion(.failure(.dataBindError))
                    return
                }
                
                completion(.success(fetchData))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// Delete Post
    func delete(postId: Int,
                completion: @escaping (Result<Bool, ServerAPIError>) -> Void) {
        
        serverAuthManager.common(path: "/api/v1/posts/\(postId)",
                                 httpMethod: .delete) { (result: Result<Bool?, ServerAPIError>) in
            
            switch result {
            case .success(let data):
                guard let fetchData = data else {
                    completion(.failure(.dataBindError))
                    return
                }
                
                completion(.success(fetchData))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// Regist Comment
    func registComment(postId: Int,
                       content: String,
                       completion: @escaping (Result<Bool, ServerAPIError>) -> Void) {
        
        var requestBody = Data()
        
        do {
            requestBody = try JSONSerialization.data(withJSONObject: ["content":content])
        } catch {
            debugPrint("ERROR - registContent")
            completion(.failure(.decodeError))
            return
        }
        
        serverAuthManager.common(path: "/api/v1/posts/\(postId)/comments/register",
                                 headers: ["Content-Type":"application/json"],
                                 httpMethod: .post,
                                 body: requestBody) { (result: Result<Bool?, ServerAPIError>) in
            switch result {
            case .success(let data):
                guard let fetchData = data else {
                    completion(.failure(.dataBindError))
                    return
                }
                
                completion(.success(fetchData))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// report Post
    func reportPost(postId: Int,
                    reportMessage: ReportMessage,
                    completion: @escaping (Result<Bool, ServerAPIError>) -> Void) {
        
        var requestBody = Data()
        
        do {
            requestBody = try JSONSerialization.data(withJSONObject: ["reason":reportMessage.rawValue])
        } catch {
            debugPrint("ERROR - registContent")
            completion(.failure(.decodeError))
            return
        }
        
        serverAuthManager.common(path: "/api/v1/posts/\(postId)/reportPost",
                                 headers: ["Content-Type":"application/json"],
                                 httpMethod: .post,
                                 body: requestBody) { (result: Result<Bool?, ServerAPIError>) in
            switch result {
            case .success(let data):
                guard let fetchData = data else {
                    completion(.failure(.dataBindError))
                    return
                }
                
                completion(.success(fetchData))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(.failureError))
            }
        }
    }
    
    /// report Comment
    func reportComment(commentId: Int,
                       reportMessage: ReportMessage,
                       completion: @escaping (Result<Bool, ServerAPIError>) -> Void) {
        
        var requestBody = Data()
        
        do {
            requestBody = try JSONSerialization.data(withJSONObject: ["reason":reportMessage.rawValue])
        } catch {
            debugPrint("ERROR - registContent")
            completion(.failure(.decodeError))
            return
        }
        
        serverAuthManager.common(path: "/api/v1/posts/\(commentId)/reportComment",
                                 headers: ["Content-Type":"application/json"],
                                 httpMethod: .post,
                                 body: requestBody) { (result: Result<Bool?, ServerAPIError>) in
            switch result {
            case .success(let data):
                guard let fetchData = data else {
                    completion(.failure(.dataBindError))
                    return
                }
                
                completion(.success(fetchData))
            case .failure(let error):
                debugPrint(error)
                completion(.failure(.failureError))
            }
        }
    }
}

