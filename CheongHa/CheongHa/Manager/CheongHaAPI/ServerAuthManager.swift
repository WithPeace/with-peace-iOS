//
//  ServerAuthManager.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/3/24.
//

import Foundation

class ServerAuthManager {
    private let networkManager = NetworkManager.shared
    private let keyChainManager = KeychainManager()
    private let signRepository = SignRepository()
    
    //TODO: Status코드에 따른 에러 해결
    func common<DataType: Codable>(path: String,
                                   queryItems: [URLQueryItem] = [],
                                   headers: Dictionary<String, String> = [:],
                                   httpMethod: HTTPMethod,
                                   body: Data? = nil,
                                   completion: @escaping (Result<DataType?, ServerAPIError>) -> Void) {
        
        // baseURL with Bundle
        guard let baseURL = Bundle.main.apiKey else {
            completion(.failure(.bundleURLError))
            return
        }
        
        // Token
        guard let keyChainAccessToken = keyChainManager.get(account: "accessToken"),
              let accessToken = String(data: keyChainAccessToken, encoding: .utf8) else {
            completion(.failure(.notHaveToken))
            return
        }
        
        // Header
        var endpointHeader = headers
        endpointHeader["Authorization"] = "Bearer \(accessToken)"
        
        let endPoint = EndPoint(baseURL: baseURL,
                                path: path,
                                port: 8080,
                                scheme: "http",
                                queryItems: queryItems,
                                headers: endpointHeader,
                                method: httpMethod,
                                body: body)
        
        networkManager.newfetchData(endpoint: endPoint) { result in
            switch result {
            case .success(let getData):
                switch getData.statusCode {
                case .informationalResponse:
                    completion(.failure(.unKnownError))
                    debugPrint("StatusCode - 100 On ServerAuthManager")
                    return
                case .successRequest:
                    do {
                        guard let decodedData = try? JSONDecoder().decode(ServerNetworkDTO<DataType>.self,
                                                                          from: getData.resultData),
                              let resultData = decodedData.data else {
                            completion(.failure(.decodeError))
                            return
                        }
                        
                        completion(.success(resultData))
                    }
                case .redirection:
                    completion(.failure(.unKnownError))
                    debugPrint("StatusCode - 300 On ServerAuthManager")
                    return
                case .clientErrors:
                    // 400
                    do {
                        guard let decodedData = try? JSONDecoder().decode(ServerNetworkDTO<ServerNetworkErrorData>.self,
                                                                          from: getData.resultData) else {
                            completion(.failure(.decodeError))
                            return
                        }
                        
                        debugPrint(decodedData.error?.message)
                        debugPrint(decodedData.error?.code)
                        debugPrint(endPoint.generateURL())
                        
                        if decodedData.error?.code == 40100 {
                            self.signRepository.performRefresh { result in
                                switch result {
                                case .success(let data):
                                    print(data)
                                case .failure(let error):
                                    completion(.failure(.unKnownError))
                                    debugPrint("Error : ", error)
                                }
                            }
                        }
                        
                        //access 만료시에 호출됨
                        if decodedData.error?.code == 40101 {
                            self.signRepository.performRefresh { result in
                                switch result {
                                case .success(let data):
                                    print(data)
                                case .failure(let error):
                                    completion(.failure(.unKnownError))
                                    debugPrint("Error : ", error)
                                }
                            }
                        }
                    }
                    
                    return
                case .serverErrors:
                    // 500
                    // TODO: 서버 오류.
                    guard let decodedData = try? JSONDecoder().decode(ServerNetworkDTO<ServerNetworkErrorData>.self,
                                                                      from: getData.resultData) else {
                        completion(.failure(.decodeError))
                        return
                    }
                    print(decodedData)
                    completion(.failure(.unKnownError))
                    return
                }
            case .failure(_):
                debugPrint("ERROR - ServerAuthManager logic")
                return
            }
        }
    }
}
