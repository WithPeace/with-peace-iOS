//
//  NetworkManager.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/12/24.
//

import Foundation

struct NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(endpoint: EndPoint, completion: @escaping (Result<Data, NetworkError>) -> Void) {
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
            switch response.statusCode {
            case 100...199:
                break
            case 200...299:
                break
            case 300...399:
                break
            case 400:
                completion(.failure(.badRequest))
            case 401:
                completion(.failure(.unauthorized))
            case 403:
                completion(.failure(.forbidden))
            case 404:
                completion(.failure(.notFound))
            case 422:
                completion(.failure(.unprocessableEntity))
            case 500...599:
                completion(.failure(.internalServerError))
            default:
                break
            }
            
            guard let data = data else {
                completion(.failure(.getDataError))
                return
            }
            
            completion(.success(data))
        }
        task.resume()
    }
}
