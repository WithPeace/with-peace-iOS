//
//  PostManager.swift
//  WithPeace
//
//  Created by Hemg on 3/20/24.
//

import Foundation

final class PostManager {
    
    func createRequest(postModel: PostModel, accessToken: String) throws -> URLRequest {
        let boundary = "Boundary-\(UUID().uuidString)"
        guard let baseURL = Bundle.main.apiKey else {
            print("baseURL Error")
            throw NetworkError.badRequest
        }
        
        let headers = ["Authorization":"Bearer \(accessToken)",
                       "Content-Type": "multipart/form-data; boundary=\(boundary)"]
        let endPoint = EndPoint(baseURL: baseURL,
                                path: "/api/v1/posts/register",
                                port: 8080,
                                scheme: "http",
                                headers: headers,
                                method: .post)
        
        guard let url = endPoint.generateURL() else {
            throw NetworkError.badRequest
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0)}
        
        var body = Data()
        
        body.append(convertFormField(name: "title", value: postModel.title, boundary: boundary))
        body.append(convertFormField(name: "description", value: postModel.content, boundary: boundary))
        body.append(convertFormField(name: "category", value: postModel.type, boundary: boundary))
        
        for imageData in postModel.imageData {
            body.append(convertFileData(fieldName: "image_Files",
                                        fileName: "image.png",
                                        mimeType: "image/png",
                                        fileData: imageData,
                                        boundary: boundary))
        }
        
        body.append("--\(boundary)--\r\n")
        request.httpBody = body
        
        return request
    }
    
    private func convertFormField(name: String, value: String, boundary: String) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n")
        data.append("\(value)\r\n")
        
        return data
    }
    
    private func convertFileData(fieldName: String,
                                 fileName: String,
                                 mimeType: String,
                                 fileData: Data,
                                 boundary: String) -> Data {
        var data = Data()
        data.append("--\(boundary)\r\n")
        data.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.append("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.append("\r\n")
        
        return data
    }
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
