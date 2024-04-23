//
//  PostManager.swift
//  WithPeace
//
//  Created by Hemg on 3/21/24.
//

import UIKit

final class PostRepository {
    private let keychainManager = KeychainManager()
    
    func fetchPost(postId: Int, completion: @escaping (Result<[PostModel], NetworkError>) -> Void) {
        do {
            let endPoint = try createFetchPostEndPoint(postId: postId)
            NetworkManager.shared.fetchData(endpoint: endPoint) { result in
                switch result {
                case .success(let data):
                    do {
                        let post = try JSONDecoder().decode([PostModel].self, from: data)
                        completion(.success(post))
                    } catch {
                        completion(.failure(.defaultsError))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(.getDataError))
        }
    }
    
    func uploadPost(postModel: PostModel, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        do {
            let endPoint = try createPostEndPoint(postModel: postModel)
            NetworkManager.shared.fetchData(endpoint: endPoint, completion: completion)
        } catch {
            completion(.failure(.getDataError))
        }
    }
    
    private func createFetchPostEndPoint(postId: Int) throws -> EndPoint {
        guard let baseURL = Bundle.main.apiKey else {
            print("baseURL Error")
            throw NetworkError.badRequest
        }
        
        guard let tokenData = keychainManager.get(account: "accessToken"),
              let tokenString = String(data: tokenData, encoding: .utf8) else {
            print("토큰을 가져오는데 실패했습니다.")
            throw SignRepositoryError.notKeychain
        }
        let headers = ["Authorization": "Bearer \(tokenString)"]
        let path = "/api/v1/posts/\(postId)"
        
        return EndPoint(baseURL: baseURL,
                        path: path,
                        port: 8080,
                        scheme: "http",
                        headers: headers,
                        method: .get)
    }
    
    private func createPostEndPoint(postModel: PostModel) throws -> EndPoint {
        guard let baseURL = Bundle.main.apiKey else {
            print("baseURL Error")
            throw NetworkError.badRequest
        }
        
        guard let tokenData = keychainManager.get(account: "accessToken"),
              let tokenString = String(data: tokenData, encoding: .utf8) else {
            print("토큰을 가져오는데 실패했습니다.")
            throw SignRepositoryError.notKeychain
        }
        
        var multipartFormData = MultipartFormData()
        guard let contentType = multipartFormData.generateHeader()["Content-Type"] else {
            throw NetworkError.getDataError
        }
        let headers = ["Authorization": "Bearer \(tokenString)",
                       "Content-Type": contentType]
        let apiEndPoint = "/api/v1/posts/register"
        prepareFormData(multipartFormData: &multipartFormData, postModel: postModel)
        let body = multipartFormData.generateData()
        
        return EndPoint(baseURL: baseURL,
                        path: apiEndPoint,
                        port: 8080,
                        scheme: "http",
                        headers: headers,
                        method: .post,
                        body: body)
    }
    
    private func prepareFormData(multipartFormData: inout MultipartFormData, postModel: PostModel) {
        multipartFormData.createFormFiled(name: "title", value: postModel.title)
        multipartFormData.createFormFiled(name: "content", value: postModel.content)
        multipartFormData.createFormFiled(name: "type", value: postModel.type)
        for (index, imageData) in postModel.imageFiles.enumerated() {
            let fileName = "image\(index).jpg"
            multipartFormData.addFilesBodyData(fieldName: "imageFiles[]",
                                               fileName: fileName,
                                               mimeType: "image/jpeg",
                                               fileData: imageData)
        }
    }
}
