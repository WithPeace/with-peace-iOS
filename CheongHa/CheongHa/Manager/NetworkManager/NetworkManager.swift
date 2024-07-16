//
//  NetworkManager.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/12/24.
//

import Foundation

struct NetworkManager {
    typealias StatusWithData = (statusCode: StatusCode, resultData: Data)
    static let shared = NetworkManager()
    
    private init() {}
    
    /// 기존 fetchData
    func fetchData(endpoint: EndPoint, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let request = endpoint.genreateURLRequest()
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10.0
        configuration.timeoutIntervalForResource = 10.0
        
        let urlSession = URLSession(configuration: configuration)
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.defaultsError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            
            debugPrint("NETWORK RESPONSE: ", response.statusCode)
            switch response.statusCode {
            case 100...199:
                break
            case 200...299:
                break
            case 300...399:
                break
            case 400:
                completion(.failure(.badRequest))
                return
            case 401:
                completion(.failure(.unauthorized))
                return
            case 403:
                completion(.failure(.forbidden))
                return
            case 404:
                completion(.failure(.notFound))
                return
            case 422:
                completion(.failure(.unprocessableEntity))
                return
            case 500...599:
                completion(.failure(.internalServerError))
                return
            default:
                debugPrint("NETWORK 알 수 없는 ERROR")
                return
            }
            
            guard let data = data else {
                completion(.failure(.getDataError))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
    
    // 단순화
    func newfetchData(endpoint: EndPoint, completion: @escaping (Result<(StatusWithData), NetworkError>) -> Void) {
        let request = endpoint.genreateURLRequest()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.defaultsError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            
            debugPrint("NETWORK RESPONSE: ", response.statusCode)
            
            guard let data = data else {
                completion(.failure(.getDataError))
                return
            }
            
            let statusCode = response.statusCode
            switch statusCode {
            case 100...199:
                completion(.success((.informationalResponse, data)))
                return
            case 200...299:
                completion(.success((.successRequest, data)))
                return
            case 300...399:
                completion(.success((.redirection, data)))
                return
            case 400...499:
                completion(.success((.clientErrors, data)))
                return
            case 500...599:
                completion(.success((.serverErrors, data)))
                return
            default:
                debugPrint("NETWORK 알 수 없는 ERROR")
                completion(.failure(.defaultsError))
                return
            }
        }
        task.resume()
    }
    
    /// 직접 받아온 URL 사용
    func fetchData(url: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let requestURL = URL(string: url) else {
            completion(.failure(.badRequest))
            return
        }
        
        let request = URLRequest(url: requestURL)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.defaultsError))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.responseError))
                return
            }
            
            debugPrint("NETWORK RESPONSE: ", response.statusCode)
            
            guard let data = data else {
                completion(.failure(.getDataError))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
