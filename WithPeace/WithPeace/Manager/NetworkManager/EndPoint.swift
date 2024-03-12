//
//  EndPoint.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/12/24.
//

import Foundation

final class EndPoint {
    private let baseURL: String
    private let path: String
    private let scheme: String
    private let queryItems: [URLQueryItem]
    private let headers: [String: String]
    private let method: HTTPMethod
    private let body: Data?
    
    init(baseURL: String,
         path: String,
         scheme: String = "https",
         queryItems: [URLQueryItem] = [],
         headers: Dictionary<String, String> = [:],
         method: HTTPMethod,
         body: Data? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.scheme = scheme
        self.queryItems = queryItems
        self.method = method
        self.headers = headers
        self.body = body
    }
    
    func generateURL() -> URL? {
        var resultUrlComponents = URLComponents()
        
        resultUrlComponents.scheme = scheme
        resultUrlComponents.host = baseURL
        resultUrlComponents.path = path
        resultUrlComponents.queryItems = queryItems
        
        return resultUrlComponents.url
    }
    
    func genreateURLRequest() -> URLRequest {
        guard let url = generateURL() else {
            fatalError()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        for headerItem in headers {
            request.addValue(headerItem.value, forHTTPHeaderField: headerItem.key)
        }
        
        return request
    }
}
