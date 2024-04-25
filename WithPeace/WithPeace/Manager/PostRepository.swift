//
//  PostManager.swift
//  WithPeace
//
//  Created by Hemg on 3/21/24.
//

import UIKit

final class PostRepository {
    private let keychainManager = KeychainManager()
    
    func uploadPost(postModel: PostModel, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        do {
            let endPoint = try createPostEndPoint(postModel: postModel)
            NetworkManager.shared.fetchData(endpoint: endPoint, completion: completion)
        } catch {
            completion(.failure(.getDataError))
        }
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

//MARK: 게시판 리스트 업로드
extension PostRepository {
    //TODO: 게시글 리스트업로드
    func fetchPostsList(type: String, pageIndex: Int, pageSize: Int, completion: @escaping (Result<[PostListModel], NetworkError>) -> Void) {
        do {
            let endPoint = try createFetchPostsListEndPoint(type: type, pageIndex: pageIndex, pageSize: pageSize)
            NetworkManager.shared.fetchData(endpoint: endPoint) { result in
                switch result {
                case .success(let data):
                    do {
                        let postsList = try JSONDecoder().decode(PostListResponse.self, from: data)
                        completion(.success(postsList.data))
                        print("포스트레포 리스트업로드 성공")
                    } catch {
                        completion(.failure(.responseError))
                        print("포스트레포 리스트업로드 실패")
                    }
                case .failure(let error):
                    completion(.failure(error))
                    print("포스트레포 리스트업로드 실패의 실패")
                }
            }
        } catch {
            completion(.failure(.getDataError))
        }
    }
    
    //TODO: 게시글 리스트 엔포
    private func createFetchPostsListEndPoint(type: String, pageIndex: Int, pageSize: Int) throws -> EndPoint {
        guard let baseURL = Bundle.main.apiKey else {
            throw NetworkError.badRequest
        }
        
        guard let tokenData = keychainManager.get(account: "accessToken"),
              let tokenString = String(data: tokenData, encoding: .utf8) else {
            throw SignRepositoryError.notKeychain
        }
        
        let headers = ["Authorization": "Bearer \(tokenString)"]
        let queryItems = [URLQueryItem(name: "type", value: type),
                          URLQueryItem(name: "pageIndex", value: "\(pageIndex)"),
                          URLQueryItem(name: "pageSize", value: "\(pageSize)")]
        
        return EndPoint(baseURL: baseURL,
                        path: "/api/v1/posts",
                        port: 8080,
                        scheme: "http",
                        queryItems: queryItems,
                        headers: headers,
                        method: .get)
    }
}
